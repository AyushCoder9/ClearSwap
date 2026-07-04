import Foundation
import SwiftData

enum SeedDataService {
    @MainActor
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Deal>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        let locations = [
            MeetupLocation(name: "Select City Walk, Saket", latitude: 28.5244, longitude: 77.2066),
            MeetupLocation(name: "Phoenix Palladium, Mumbai", latitude: 19.0860, longitude: 72.8879),
            MeetupLocation(name: "Forum Mall, Bangalore", latitude: 12.9340, longitude: 77.6100)
        ]

        let deals: [Deal] = [
            Deal(
                itemTitle: "iPhone 15 Pro 256GB",
                category: "Electronics",
                agreedPrice: 89_000,
                condition: .mint,
                sellerName: "Arjun K.",
                buyerName: "Priya M.",
                meetupLocation: locations[0],
                meetupTime: Date().addingTimeInterval(3600),
                escrowStatus: .escrowFunded,
                serialNumber: "IP15P8X2",
                imageSystemName: "iphone.gen3"
            ),
            Deal(
                itemTitle: "Sony WH-1000XM5",
                category: "Audio",
                agreedPrice: 22_000,
                condition: .good,
                sellerName: "Arjun K.",
                buyerName: "Rahul S.",
                meetupLocation: locations[1],
                meetupTime: Date().addingTimeInterval(86400),
                escrowStatus: .inTransit,
                serialNumber: "SONY5XM5",
                imageSystemName: "headphones"
            ),
            Deal(
                itemTitle: "MacBook Air M2",
                category: "Electronics",
                agreedPrice: 78_000,
                condition: .mint,
                sellerName: "Arjun K.",
                buyerName: "Neha T.",
                meetupLocation: locations[2],
                meetupTime: Date().addingTimeInterval(-86400),
                escrowStatus: .completed,
                serialNumber: "MBA2M2X1",
                imageSystemName: "laptopcomputer"
            )
        ]

        deals.forEach { context.insert($0) }

        let valuations = [
            ItemValuation(
                itemTitle: "iPhone 15 Pro 256GB",
                category: "Electronics",
                baseMarketPrice: 95_000,
                condition: .mint,
                historicalPrices: ValuationService.shared.generateHistoricalPrices(basePrice: 95000)
            ),
            ItemValuation(
                itemTitle: "AirPods Pro 2",
                category: "Audio",
                baseMarketPrice: 20_000,
                condition: .good,
                historicalPrices: ValuationService.shared.generateHistoricalPrices(basePrice: 20000)
            )
        ]
        valuations.forEach { context.insert($0) }

        try? context.save()
    }
}
