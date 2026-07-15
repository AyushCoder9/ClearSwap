import Foundation
import SwiftData

@MainActor
@Observable
final class CheckoutViewModel {
    var isProcessing: Bool = false
    var errorMessage: String?

    func simulateScan(
        deal: Deal,
        context: ModelContext,
        onSuccess: @escaping (WalletPassMetadata) -> Void
    ) {
        isProcessing = true
        errorMessage = nil
        Task {
            do {
                let hash = deal.releaseHash ?? "DEMOHASH"
                let authenticated = try await BiometricService.authenticate(
                    reason: "Release \(CurrencyFormatting.string(from: deal.agreedPrice)) from escrow"
                )
                guard authenticated else {
                    errorMessage = "Biometric authentication failed."
                    isProcessing = false
                    return
                }

                try await EscrowService.shared.releaseFunds(dealID: deal.id, hash: hash)
                deal.escrowStatus = .completed
                deal.completedAt = .now

                let receipt = ReceiptRecord(
                    dealID: deal.id,
                    itemTitle: deal.itemTitle,
                    amountPaid: deal.agreedPrice,
                    serialNumber: deal.serialNumber,
                    sellerName: deal.sellerName,
                    buyerName: deal.buyerName
                )
                context.insert(receipt)
                try? context.save()

                await LiveActivityService.shared.endActivity()
                HapticsService.shared.playWalletAdd()

                let metadata = WalletPassMetadata(
                    dealID: deal.id,
                    itemTitle: deal.itemTitle,
                    serialNumber: deal.serialNumber,
                    amountPaid: deal.agreedPrice,
                    sellerName: deal.sellerName,
                    buyerName: deal.buyerName,
                    purchaseDate: .now,
                    warrantyExpires: Calendar.current.date(byAdding: .day, value: 30, to: .now) ?? .now
                )
                onSuccess(metadata)
            } catch {
                errorMessage = error.localizedDescription
            }
            isProcessing = false
        }
    }
}

// MARK: - Formatting update
