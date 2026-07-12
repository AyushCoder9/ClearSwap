import Foundation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class DashboardViewModel {
    var activeDeals: [Deal] = []
    var isLoading = false

    func filteredActiveDeals(from deals: [Deal]) -> [Deal] {
        deals.filter { !$0.escrowStatus.isTerminal }
    }

    func totalLockedEscrow(from deals: [Deal]) -> Decimal {
        EscrowService.shared.totalLockedAmount(deals: filteredActiveDeals(from: deals))
    }

    func fundEscrow(deal: Deal) async {
        isLoading = true
        await EscrowService.shared.fundEscrow(deal: deal)
        HapticsService.shared.playTap()
        isLoading = false
    }

    func startMeetup(deal: Deal) async {
        await EscrowService.shared.startMeetup(deal: deal)
        await LiveActivityService.shared.startMeetupActivity(for: deal)
        HapticsService.shared.playTap()
    }
}
