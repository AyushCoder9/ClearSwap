import Foundation

struct MarketDataPoint: Identifiable, Sendable {
    let id = UUID()
    let dayOffset: Int
    let price: Double
    let condition: ItemCondition
}

struct HistoricalPricePoint: Identifiable, Sendable {
    let id = UUID()
    let day: Int
    let price: Double
}


@MainActor
final class ValuationService: ObservableObject {
    static let shared = ValuationService()

    func generateHistoricalPrices(basePrice: Double, days: Int = 30) -> [Double] {
        var prices: [Double] = []
        var current = basePrice * 1.08
        for i in 0..<days {
            let noise = Double.random(in: -0.025...0.015)
            current = max(basePrice * 0.65, current * (1 + noise))
            prices.append(current)
            _ = i
        }
        return prices.reversed()
    }

    func bellCurvePoints(basePrice: Double, condition: ItemCondition) -> [MarketDataPoint] {
        let adjustedBase = basePrice * condition.priceMultiplier
        return (-15...15).map { offset in
            let x = Double(offset)
            let bell = exp(-pow(x, 2) / 80)
            let price = adjustedBase * (0.85 + bell * 0.25)
            return MarketDataPoint(dayOffset: offset, price: price, condition: condition)
        }
    }

    func recommendedRange(basePrice: Decimal, condition: ItemCondition) -> (low: Decimal, high: Decimal) {
        let base = (basePrice as NSDecimalNumber).doubleValue * condition.priceMultiplier
        let low = Decimal(base * 0.92)
        let high = Decimal(base * 1.08)
        return (low, high)
    }

    func priceForCondition(basePrice: Decimal, condition: ItemCondition) -> Decimal {
        basePrice * Decimal(condition.priceMultiplier)
    }

    func lookupMarketPrice(itemTitle: String, category: String) -> Decimal {
        let catalog: [String: Decimal] = [
            "iPhone 15 Pro": 89_000,
            "iPad Mini": 42_000,
            "MacBook Air M2": 78_000,
            "AirPods Pro 2": 18_500,
            "Apple Watch Ultra 2": 62_000,
            "PS5 Slim": 45_000,
            "Nintendo Switch OLED": 28_000,
            "Sony WH-1000XM5": 22_000,
            "DJI Mini 4 Pro": 58_000,
            "GoPro Hero 12": 32_000
        ]
        if let price = catalog[itemTitle] { return price }
        let hash = abs(category.hashValue % 50_000) + 15_000
        return Decimal(hash)
    }
}

// MARK: - Formatting update
