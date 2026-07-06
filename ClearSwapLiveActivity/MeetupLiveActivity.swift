import ActivityKit
import SwiftUI
import WidgetKit

struct MeetupLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MeetupActivityAttributes.self) { context in
            lockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.itemTitle)
                            .font(.caption.bold())
                            .lineLimit(1)
                        Text(context.attributes.meetupName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(context.attributes.agreedPrice)
                            .font(.caption.bold())
                            .foregroundStyle(.green)
                        if context.state.escrowFunded {
                            Label("Secured", systemImage: "checkmark.shield.fill")
                                .font(.caption2)
                                .foregroundStyle(.green)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    meetupProgress(context: context)
                }
            } compactLeading: {
                Image(systemName: "location.fill")
                    .foregroundStyle(.green)
            } compactTrailing: {
                Text("\(context.state.minutesRemaining)m")
                    .font(.caption2.bold())
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundStyle(.green)
            }
        }
    }

    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<MeetupActivityAttributes>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("ClearSwap Meetup")
                    .font(.caption.bold())
                Spacer()
                if context.state.escrowFunded {
                    Text("ESCROW SECURED")
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.2))
                        .foregroundStyle(.green)
                        .clipShape(Capsule())
                }
            }
            Text(context.attributes.itemTitle)
                .font(.headline)
            meetupProgress(context: context)
            HStack {
                Label("\(context.state.distanceMeters)m away", systemImage: "location")
                Spacer()
                Label("\(context.state.minutesRemaining) min", systemImage: "clock")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .activityBackgroundTint(Color(red: 0.06, green: 0.08, blue: 0.10))
    }

    @ViewBuilder
    private func meetupProgress(context: ActivityViewContext<MeetupActivityAttributes>) -> some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.gray.opacity(0.3))
                    Capsule()
                        .fill(.green.gradient)
                        .frame(width: geo.size.width * context.state.buyerProgress)
                }
            }
            .frame(height: 6)
            HStack {
                Text(context.attributes.buyerName)
                    .font(.caption2)
                Spacer()
                Text(context.attributes.sellerName)
                    .font(.caption2)
            }
            .foregroundStyle(.secondary)
        }
    }
}

@main
struct ClearSwapLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        MeetupLiveActivity()
    }
}
