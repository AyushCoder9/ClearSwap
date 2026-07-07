import Foundation

public enum CurrencyFormatting {
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "INR"
        f.currencySymbol = "₹"
        f.maximumFractionDigits = 0
        return f
    }()

    public static func string(from decimal: Decimal) -> String {
        formatter.string(from: decimal as NSDecimalNumber) ?? "₹0"
    }

    public static func compact(from decimal: Decimal) -> String {
        let value = (decimal as NSDecimalNumber).doubleValue
        if value >= 100_000 {
            return String(format: "₹%.1fL", value / 100_000)
        }
        if value >= 1_000 {
            return String(format: "₹%.1fK", value / 1_000)
        }
        return string(from: decimal)
    }
}

// MARK: - Formatting update
