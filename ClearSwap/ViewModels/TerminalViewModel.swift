import Foundation
import SwiftUI
import SwiftData

@MainActor
@Observable
final class TerminalViewModel {
    var qrPayload: String = ""
    var pulse: Bool = false
    var brightnessBoosted: Bool = false
    var isReady: Bool = false

    func prepare(deal: Deal, context: ModelContext) async {
        if deal.releaseHash == nil {
            await EscrowService.shared.fundEscrow(deal: deal)
        }
        if deal.escrowStatus == .escrowFunded || deal.escrowStatus == .inTransit {
            await EscrowService.shared.markReady(deal: deal)
        }
        refreshQR(deal: deal, context: context)
        isReady = true
    }

    func refreshQR(deal: Deal, context: ModelContext) {
        let hash = deal.releaseHash ?? UUID().uuidString.prefix(8).uppercased()
        deal.releaseHash = String(hash)
        let payload = QRCodeService.payload(for: deal, hash: String(hash))
        qrPayload = payload.encodedString() ?? ""
        try? context.save()
    }

    func boostBrightness() {
        brightnessBoosted = true
        UIScreen.main.brightness = 1.0
    }

    func restoreBrightness() {
        guard brightnessBoosted else { return }
        UIScreen.main.brightness = 0.5
        brightnessBoosted = false
    }

    func startPulse() {
        pulse = true
    }
}
