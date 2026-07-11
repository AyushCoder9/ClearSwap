import Foundation

/// Thread-safe escrow lifecycle shared between app and Live Activity extension.
public enum EscrowStatus: String, Codable, Sendable, CaseIterable {
    case draft
    case priceLocked
    case escrowPending
    case escrowFunded
    case inTransit
    case readyForExchange
    case releasing
    case released
    case completed
    case cancelled
    case disputed

    public var displayTitle: String {
        switch self {
        case .draft: "Draft"
        case .priceLocked: "Price Locked"
        case .escrowPending: "Awaiting Escrow"
        case .escrowFunded: "Escrow Secured"
        case .inTransit: "En Route"
        case .readyForExchange: "Ready for Exchange"
        case .releasing: "Releasing Funds"
        case .released: "Funds Released"
        case .completed: "Completed"
        case .cancelled: "Cancelled"
        case .disputed: "Disputed"
        }
    }

    public var isTerminal: Bool {
        switch self {
        case .completed, .cancelled, .disputed: true
        default: false
        }
    }

    public var showsLiveActivity: Bool {
        switch self {
        case .escrowFunded, .inTransit, .readyForExchange, .releasing: true
        default: false
        }
    }
}

public enum ItemCondition: String, Codable, Sendable, CaseIterable, Identifiable {
    case fair
    case good
    case mint
    case new

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .fair: "Fair"
        case .good: "Good"
        case .mint: "Mint"
        case .new: "New"
        }
    }

    public var priceMultiplier: Double {
        switch self {
        case .fair: 0.72
        case .good: 0.85
        case .mint: 0.94
        case .new: 1.0
        }
    }
}

public enum UserRole: String, Codable, Sendable {
    case seller
    case buyer
}

public struct MeetupLocation: Codable, Sendable, Hashable {
    public var name: String
    public var latitude: Double
    public var longitude: Double

    public init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct DealSnapshot: Codable, Sendable, Identifiable, Hashable {
    public let id: UUID
    public var itemTitle: String
    public var category: String
    public var agreedPrice: Decimal
    public var condition: ItemCondition
    public var sellerName: String
    public var buyerName: String
    public var meetupLocation: MeetupLocation
    public var meetupTime: Date
    public var escrowStatus: EscrowStatus
    public var serialNumber: String
    public var imageSystemName: String

    public init(
        id: UUID = UUID(),
        itemTitle: String,
        category: String,
        agreedPrice: Decimal,
        condition: ItemCondition,
        sellerName: String,
        buyerName: String,
        meetupLocation: MeetupLocation,
        meetupTime: Date,
        escrowStatus: EscrowStatus = .draft,
        serialNumber: String = UUID().uuidString.prefix(8).uppercased(),
        imageSystemName: String = "shippingbox.fill"
    ) {
        self.id = id
        self.itemTitle = itemTitle
        self.category = category
        self.agreedPrice = agreedPrice
        self.condition = condition
        self.sellerName = sellerName
        self.buyerName = buyerName
        self.meetupLocation = meetupLocation
        self.meetupTime = meetupTime
        self.escrowStatus = escrowStatus
        self.serialNumber = String(serialNumber)
        self.imageSystemName = imageSystemName
    }
}

public struct QRPayload: Codable, Sendable {
    public let dealID: UUID
    public let releaseHash: String
    public let expiresAt: Date
    public let amount: Decimal

    public init(dealID: UUID, releaseHash: String, expiresAt: Date, amount: Decimal) {
        self.dealID = dealID
        self.releaseHash = releaseHash
        self.expiresAt = expiresAt
        self.amount = amount
    }

    public func encodedString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return data.base64EncodedString()
    }

    public static func decode(from string: String) -> QRPayload? {
        guard let data = Data(base64Encoded: string) else { return nil }
        return try? JSONDecoder().decode(QRPayload.self, from: data)
    }
}

// MARK: - Formatting update
