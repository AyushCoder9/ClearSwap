import Foundation
import SwiftUI

@MainActor
@Observable
final class ValuationViewModel {
    var itemTitle: String = "iPhone 15 Pro 256GB"
    var category: String = "Electronics"
    var condition: ItemCondition = .mint
    var basePrice: Decimal = 95_000
    var selectedOffset: Int = 0
    var chartAnimates: Bool = false
    var showDealCreated: Bool = false

    private let service = ValuationService.shared

    var bellPoints: [MarketDataPoint] {
        service.bellCurvePoints(
            basePrice: (basePrice as NSDecimalNumber).doubleValue,
            condition: condition
        )
    }

    var recommended: Decimal {
        service.priceForCondition(basePrice: basePrice, condition: condition)
    }

    var priceRange: (low: Decimal, high: Decimal) {
        service.recommendedRange(basePrice: basePrice, condition: condition)
    }

    func refreshPrice() {
        basePrice = service.lookupMarketPrice(itemTitle: itemTitle, category: category)
    }

    func animateIn() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            chartAnimates = true
        }
    }

    func scrub(to offset: Int) {
        let clamped = max(-15, min(15, offset))
        if clamped != selectedOffset {
            selectedOffset = clamped
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}
