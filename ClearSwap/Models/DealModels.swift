import Foundation
import SwiftData

@Model
final class Deal: @unchecked Sendable {
    @Attribute(.unique) var id: UUID
    var itemTitle: String
    var category: String
    var agreedPrice: Decimal
    var conditionRaw: String
    var sellerName: String
    var buyerName: String
    var meetupName: String
    var meetupLatitude: Double
    var meetupLongitude: Double
    var meetupTime: Date
    var escrowStatusRaw: String
    var serialNumber: String
    var imageSystemName: String
    var createdAt: Date
    var completedAt: Date?
    var releaseHash: String?

    var condition: ItemCondition {
        get { ItemCondition(rawValue: conditionRaw) ?? .good }
        set { conditionRaw = newValue.rawValue }
    }

    var escrowStatus: EscrowStatus {
        get { EscrowStatus(rawValue: escrowStatusRaw) ?? .draft }
        set { escrowStatusRaw = newValue.rawValue }
    }

    var meetupLocation: MeetupLocation {
        MeetupLocation(name: meetupName, latitude: meetupLatitude, longitude: meetupLongitude)
    }

    init(
        id: UUID = UUID(),
        itemTitle: String,
        category: String,
        agreedPrice: Decimal,
        condition: ItemCondition = .good,
        sellerName: String,
        buyerName: String,
        meetupLocation: MeetupLocation,
        meetupTime: Date,
        escrowStatus: EscrowStatus = .draft,
        serialNumber: String = UUID().uuidString.prefix(8).uppercased(),
        imageSystemName: String = "shippingbox.fill",
        createdAt: Date = .now,
        completedAt: Date? = nil,
        releaseHash: String? = nil
    ) {
        self.id = id
        self.itemTitle = itemTitle
        self.category = category
        self.agreedPrice = agreedPrice
        self.conditionRaw = condition.rawValue
        self.sellerName = sellerName
        self.buyerName = buyerName
        self.meetupName = meetupLocation.name
        self.meetupLatitude = meetupLocation.latitude
        self.meetupLongitude = meetupLocation.longitude
        self.meetupTime = meetupTime
        self.escrowStatusRaw = escrowStatus.rawValue
        self.serialNumber = String(serialNumber)
        self.imageSystemName = imageSystemName
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.releaseHash = releaseHash
    }

    func snapshot() -> DealSnapshot {
        DealSnapshot(
            id: id,
            itemTitle: itemTitle,
            category: category,
            agreedPrice: agreedPrice,
            condition: condition,
            sellerName: sellerName,
            buyerName: buyerName,
            meetupLocation: meetupLocation,
            meetupTime: meetupTime,
            escrowStatus: escrowStatus,
            serialNumber: serialNumber,
            imageSystemName: imageSystemName
        )
    }
}

@Model
final class ItemValuation {
    @Attribute(.unique) var id: UUID
    var itemTitle: String
    var category: String
    var baseMarketPrice: Decimal
    var conditionRaw: String
    var recommendedPrice: Decimal
    var historicalPricesJSON: Data
    var updatedAt: Date

    var condition: ItemCondition {
        get { ItemCondition(rawValue: conditionRaw) ?? .good }
        set { conditionRaw = newValue.rawValue }
    }

    var historicalPrices: [Double] {
        get {
            (try? JSONDecoder().decode([Double].self, from: historicalPricesJSON)) ?? []
        }
        set {
            historicalPricesJSON = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    init(
        id: UUID = UUID(),
        itemTitle: String,
        category: String,
        baseMarketPrice: Decimal,
        condition: ItemCondition = .good,
        recommendedPrice: Decimal? = nil,
        historicalPrices: [Double] = [],
        updatedAt: Date = .now
    ) {
        self.id = id
        self.itemTitle = itemTitle
        self.category = category
        self.baseMarketPrice = baseMarketPrice
        self.conditionRaw = condition.rawValue
        let multiplier = Decimal(condition.priceMultiplier)
        self.recommendedPrice = recommendedPrice ?? (baseMarketPrice * multiplier)
        self.historicalPricesJSON = (try? JSONEncoder().encode(historicalPrices)) ?? Data()
        self.updatedAt = updatedAt
    }
}

@Model
final class ReceiptRecord {
    @Attribute(.unique) var id: UUID
    var dealID: UUID
    var itemTitle: String
    var amountPaid: Decimal
    var serialNumber: String
    var sellerName: String
    var buyerName: String
    var passAddedToWallet: Bool
    var transactionHash: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        dealID: UUID,
        itemTitle: String,
        amountPaid: Decimal,
        serialNumber: String,
        sellerName: String,
        buyerName: String,
        passAddedToWallet: Bool = false,
        transactionHash: String = UUID().uuidString,
        createdAt: Date = .now
    ) {
        self.id = id
        self.dealID = dealID
        self.itemTitle = itemTitle
        self.amountPaid = amountPaid
        self.serialNumber = serialNumber
        self.sellerName = sellerName
        self.buyerName = buyerName
        self.passAddedToWallet = passAddedToWallet
        self.transactionHash = transactionHash
        self.createdAt = createdAt
    }
}
