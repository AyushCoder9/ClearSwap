import ActivityKit
import Foundation

public struct MeetupActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var escrowStatus: EscrowStatus
        public var distanceMeters: Int
        public var minutesRemaining: Int
        public var escrowFunded: Bool
        public var buyerProgress: Double
        public var sellerProgress: Double

        public init(
            escrowStatus: EscrowStatus = .escrowFunded,
            distanceMeters: Int = 999,
            minutesRemaining: Int = 30,
            escrowFunded: Bool = true,
            buyerProgress: Double = 0.3,
            sellerProgress: Double = 0.5
        ) {
            self.escrowStatus = escrowStatus
            self.distanceMeters = distanceMeters
            self.minutesRemaining = minutesRemaining
            self.escrowFunded = escrowFunded
            self.buyerProgress = buyerProgress
            self.sellerProgress = sellerProgress
        }
    }

    public var dealID: String
    public var itemTitle: String
    public var agreedPrice: String
    public var sellerName: String
    public var buyerName: String
    public var meetupName: String

    public init(
        dealID: String,
        itemTitle: String,
        agreedPrice: String,
        sellerName: String,
        buyerName: String,
        meetupName: String
    ) {
        self.dealID = dealID
        self.itemTitle = itemTitle
        self.agreedPrice = agreedPrice
        self.sellerName = sellerName
        self.buyerName = buyerName
        self.meetupName = meetupName
    }
}

// MARK: - Formatting update
