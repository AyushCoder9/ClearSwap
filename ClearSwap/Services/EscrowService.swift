import Foundation

/// Thread-safe escrow state machine using Swift 6 actor isolation.
actor EscrowActor {
    private var deals: [UUID: DealSnapshot] = [:]
    private var statusByDeal: [UUID: EscrowStatus] = [:]

    func register(deal: DealSnapshot) {
        deals[deal.id] = deal
        statusByDeal[deal.id] = deal.escrowStatus
    }

    func status(for dealID: UUID) -> EscrowStatus {
        statusByDeal[dealID] ?? .draft
    }

    func transition(dealID: UUID, to newStatus: EscrowStatus) throws -> EscrowStatus {
        guard var deal = deals[dealID] else {
            throw EscrowError.dealNotFound
        }
        let current = statusByDeal[dealID] ?? .draft
        guard isValidTransition(from: current, to: newStatus) else {
            throw EscrowError.invalidTransition(from: current, to: newStatus)
        }
        statusByDeal[dealID] = newStatus
        deal.escrowStatus = newStatus
        deals[dealID] = deal
        return newStatus
    }

    func generateReleaseHash(for dealID: UUID) throws -> String {
        guard deals[dealID] != nil else { throw EscrowError.dealNotFound }
        let hash = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(16)
        return String(hash).uppercased()
    }

    func validateRelease(dealID: UUID, hash: String) throws -> Bool {
        guard statusByDeal[dealID] == .readyForExchange || statusByDeal[dealID] == .escrowFunded else {
            throw EscrowError.notReadyForRelease
        }
        guard !hash.isEmpty else { throw EscrowError.invalidHash }
        _ = try transition(dealID: dealID, to: .releasing)
        _ = try transition(dealID: dealID, to: .released)
        _ = try transition(dealID: dealID, to: .completed)
        return true
    }

    private func isValidTransition(from: EscrowStatus, to: EscrowStatus) -> Bool {
        switch (from, to) {
        case (.draft, .priceLocked), (.draft, .cancelled):
            true
        case (.priceLocked, .escrowPending), (.priceLocked, .cancelled):
            true
        case (.escrowPending, .escrowFunded), (.escrowPending, .cancelled):
            true
        case (.escrowFunded, .inTransit), (.escrowFunded, .readyForExchange):
            true
        case (.inTransit, .readyForExchange):
            true
        case (.readyForExchange, .releasing), (.readyForExchange, .cancelled):
            true
        case (.releasing, .released):
            true
        case (.released, .completed):
            true
        case (let a, let b) where a == b:
            true
        default:
            false
        }
    }
}

enum EscrowError: LocalizedError {
    case dealNotFound
    case invalidTransition(from: EscrowStatus, to: EscrowStatus)
    case notReadyForRelease
    case invalidHash

    var errorDescription: String? {
        switch self {
        case .dealNotFound:
            "Deal not found in escrow system."
        case .invalidTransition(let from, let to):
            "Cannot transition from \(from.displayTitle) to \(to.displayTitle)."
        case .notReadyForRelease:
            "Escrow is not ready for fund release."
        case .invalidHash:
            "Invalid release authorization hash."
        }
    }
}

@MainActor
final class EscrowService: ObservableObject {
    static let shared = EscrowService()

    private let actor = EscrowActor()
    @Published private(set) var lastError: String?

    func clearError() { lastError = nil }

    func register(deal: DealSnapshot) async {
        await actor.register(deal: deal)
    }

    func fundEscrow(deal: Deal) async {
        await actor.register(deal: deal.snapshot())
        do {
            _ = try await actor.transition(dealID: deal.id, to: .priceLocked)
            _ = try await actor.transition(dealID: deal.id, to: .escrowPending)
            _ = try await actor.transition(dealID: deal.id, to: .escrowFunded)
            deal.escrowStatus = .escrowFunded
            deal.releaseHash = await actor.generateReleaseHash(for: deal.id)
        } catch {
            lastError = error.localizedDescription
        }
    }

    func startMeetup(deal: Deal) async {
        do {
            _ = try await actor.transition(dealID: deal.id, to: .inTransit)
            deal.escrowStatus = .inTransit
        } catch {
            lastError = error.localizedDescription
        }
    }

    func markReady(deal: Deal) async {
        do {
            _ = try await actor.transition(dealID: deal.id, to: .readyForExchange)
            deal.escrowStatus = .readyForExchange
        } catch {
            lastError = error.localizedDescription
        }
    }

    func releaseFunds(dealID: UUID, hash: String) async throws {
        let success = try await actor.validateRelease(dealID: dealID, hash: hash)
        guard success else { throw EscrowError.invalidHash }
    }

    func totalLockedAmount(deals: [Deal]) -> Decimal {
        deals
            .filter { !$0.escrowStatus.isTerminal && $0.escrowStatus != .draft }
            .reduce(0) { $0 + $1.agreedPrice }
    }
}
