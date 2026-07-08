import ActivityKit
import Foundation

@MainActor
final class LiveActivityService: ObservableObject {
    static let shared = LiveActivityService()

    @Published private(set) var activeActivityID: String?
    private var updateTask: Task<Void, Never>?

    func startMeetupActivity(for deal: Deal) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = MeetupActivityAttributes(
            dealID: deal.id.uuidString,
            itemTitle: deal.itemTitle,
            agreedPrice: CurrencyFormatting.string(from: deal.agreedPrice),
            sellerName: deal.sellerName,
            buyerName: deal.buyerName,
            meetupName: deal.meetupName
        )

        let initialState = MeetupActivityAttributes.ContentState(
            escrowStatus: deal.escrowStatus,
            distanceMeters: 850,
            minutesRemaining: max(1, Int(deal.meetupTime.timeIntervalSinceNow / 60)),
            escrowFunded: true,
            buyerProgress: 0.25,
            sellerProgress: 0.4
        )

        do {
            if let existing = Activity<MeetupActivityAttributes>.activities.first {
                await existing.end(nil, dismissalPolicy: .immediate)
            }

            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            activeActivityID = activity.id
            startSimulatedUpdates(for: activity, deal: deal)
        } catch {
            print("Live Activity start failed: \(error)")
        }
    }

    func updateActivity(deal: Deal, distanceMeters: Int, minutesRemaining: Int) async {
        guard let activity = Activity<MeetupActivityAttributes>.activities.first else { return }
        let state = MeetupActivityAttributes.ContentState(
            escrowStatus: deal.escrowStatus,
            distanceMeters: distanceMeters,
            minutesRemaining: minutesRemaining,
            escrowFunded: [.escrowFunded, .inTransit, .readyForExchange, .releasing, .released, .completed].contains(deal.escrowStatus),
            buyerProgress: min(1, 1 - Double(distanceMeters) / 1000),
            sellerProgress: min(1, 1 - Double(distanceMeters) / 1200)
        )
        await activity.update(.init(state: state, staleDate: nil))
    }

    func endActivity() async {
        updateTask?.cancel()
        updateTask = nil
        for activity in Activity<MeetupActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .default)
        }
        activeActivityID = nil
    }

    private func startSimulatedUpdates(for activity: Activity<MeetupActivityAttributes>, deal: Deal) {
        updateTask?.cancel()
        updateTask = Task {
            var distance = 850
            var minutes = max(1, Int(deal.meetupTime.timeIntervalSinceNow / 60))
            while !Task.isCancelled && distance > 0 {
                try? await Task.sleep(for: .seconds(3))
                distance = max(0, distance - Int.random(in: 40...120))
                minutes = max(0, minutes - 1)
                let state = MeetupActivityAttributes.ContentState(
                    escrowStatus: deal.escrowStatus,
                    distanceMeters: distance,
                    minutesRemaining: minutes,
                    escrowFunded: true,
                    buyerProgress: min(1, 1 - Double(distance) / 1000),
                    sellerProgress: min(1, 1 - Double(distance) / 1200)
                )
                await activity.update(.init(state: state, staleDate: nil))
            }
        }
    }
}

// MARK: - Formatting update
