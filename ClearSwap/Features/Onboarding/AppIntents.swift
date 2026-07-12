import AppIntents
import Foundation

struct PriceCheckIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Fair Market Price"
    static var description = IntentDescription("Get an instant secondhand market valuation for an item.")

    @Parameter(title: "Item Name")
    var itemName: String

    @Parameter(title: "Category", default: "Electronics")
    var category: String

    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let price = await ValuationService.shared.lookupMarketPrice(itemTitle: itemName, category: category)
        let formatted = CurrencyFormatting.string(from: price)
        return .result(value: "\(itemName): fair market price is \(formatted)")
    }
}

struct EscrowStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Escrow Status"
    static var description = IntentDescription("Shows your active ClearSwap escrow summary.")

    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}

struct ClearSwapShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: PriceCheckIntent(),
            phrases: [
                "What's the fair price for \(\.$itemName) in \(.applicationName)",
                "Check market price for \(\.$itemName) with \(.applicationName)"
            ],
            shortTitle: "Price Check",
            systemImageName: "chart.line.uptrend.xyaxis"
        )
        AppShortcut(
            intent: EscrowStatusIntent(),
            phrases: [
                "Show my escrow status in \(.applicationName)",
                "ClearSwap escrow status"
            ],
            shortTitle: "Escrow Status",
            systemImageName: "lock.shield.fill"
        )
    }
}
