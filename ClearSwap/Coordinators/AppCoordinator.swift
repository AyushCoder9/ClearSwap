import SwiftUI

// MARK: - Route

enum Route: Hashable {
    case dashboard
    case valuation
    case terminal(Deal)
    case checkout(Deal)
    case success(WalletPassMetadata)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .dashboard: hasher.combine(0)
        case .valuation: hasher.combine(1)
        case .terminal(let d): hasher.combine(2); hasher.combine(d.id)
        case .checkout(let d): hasher.combine(3); hasher.combine(d.id)
        case .success(let m): hasher.combine(4); hasher.combine(m.dealID)
        }
    }

    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.dashboard, .dashboard): true
        case (.valuation, .valuation): true
        case (.terminal(let a), .terminal(let b)): a.id == b.id
        case (.checkout(let a), .checkout(let b)): a.id == b.id
        case (.success(let a), .success(let b)): a.dealID == b.dealID
        default: false
        }
    }
}

// MARK: - AppCoordinator

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var selectedTab: AppTab = .dashboard
    @Published var activeRole: UserRole = .seller
    @Published var navigationPath = NavigationPath()
    @Published var presentedDeal: Deal?
    @Published var showCheckoutSuccess = false
    @Published var checkoutMetadata: WalletPassMetadata?

    enum AppTab: Hashable {
        case dashboard
        case valuation
        case archive
        case settings
    }

    // MARK: Navigation

    func navigate(to route: Route) {
        switch route {
        case .terminal(let deal):
            presentedDeal = deal
        case .checkout(let deal):
            presentedDeal = deal
        case .success(let metadata):
            checkoutMetadata = metadata
            showCheckoutSuccess = true
        case .dashboard:
            selectedTab = .dashboard
        case .valuation:
            selectedTab = .valuation
        }
    }

    func dismiss() {
        presentedDeal = nil
    }

    func openTerminal(for deal: Deal) {
        navigate(to: .terminal(deal))
    }

    func openScanner() {
        selectedTab = .dashboard
    }

    func completeCheckout(metadata: WalletPassMetadata) {
        checkoutMetadata = metadata
        showCheckoutSuccess = true
        presentedDeal = nil
    }
}
