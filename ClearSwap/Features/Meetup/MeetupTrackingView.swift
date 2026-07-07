import MapKit
import SwiftUI

struct MeetupTrackingView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var coordinator: AppCoordinator
    @Bindable var deal: Deal

    @State private var distanceMeters: Int = 850
    @State private var minutesRemaining: Int = 15
    @State private var buyerProgress: Double = 0.25
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var pulseRadar = false
    @State private var isSimulating = false

    private var meetupCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: deal.meetupLatitude, longitude: deal.meetupLongitude)
    }

    var body: some View {
        ZStack {
            // Map
            Map(position: $cameraPosition) {
                Marker(deal.meetupName, coordinate: meetupCoordinate)
                    .tint(CSColor.accent)
            }
            .ignoresSafeArea()

            // Gradient overlay at bottom
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, CSColor.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
            }
            .ignoresSafeArea()

            // Content overlay
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 16) {
                    statusBanner
                    proximityCard
                    actionButton
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Meetup Radar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: meetupCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
            pulseRadar = true
        }
    }

    // MARK: - Status Banner

    private var statusBanner: some View {
        HStack(spacing: 12) {
            ZStack {
                ForEach(0..<2, id: \.self) { i in
                    Circle()
                        .stroke(CSColor.accent, lineWidth: 1.5)
                        .frame(width: 36, height: 36)
                        .scaleEffect(pulseRadar ? 2.0 : 1.0)
                        .opacity(pulseRadar ? 0 : 0.8)
                        .animation(
                            .easeOut(duration: 1.6).repeatForever(autoreverses: false).delay(Double(i) * 0.8),
                            value: pulseRadar
                        )
                }
                Image(systemName: "location.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(CSColor.accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                CSTypography.headline(deal.escrowStatus.displayTitle)
                CSTypography.caption(deal.meetupName)
            }
            Spacer()
            CSStatusBadge(status: deal.escrowStatus)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.white.opacity(0.0)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
        }
    }

    // MARK: - Proximity Card

    private var proximityCard: some View {
        GlassCard {
            VStack(spacing: 16) {
                HStack {
                    metricBlock(value: "\(distanceMeters)m", label: "DISTANCE")
                    Divider().frame(height: 40)
                    metricBlock(value: "\(minutesRemaining)min", label: "ETA")
                    Divider().frame(height: 40)
                    metricBlock(
                        value: CurrencyFormatting.compact(from: deal.agreedPrice),
                        label: "ESCROW"
                    )
                }

                // Approach progress bar
                VStack(spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 8)
                            Capsule()
                                .fill(LinearGradient(
                                    colors: [CSColor.accentMuted, CSColor.accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: geo.size.width * buyerProgress, height: 8)
                                .animation(.spring(response: 0.6), value: buyerProgress)
                        }
                    }
                    .frame(height: 8)
                    HStack {
                        Text("Buyer Approaching")
                            .font(.caption2)
                            .foregroundStyle(CSColor.textSecondary)
                        Spacer()
                        Text("\(Int(buyerProgress * 100))%")
                            .font(.caption2.bold())
                            .foregroundStyle(CSColor.accent)
                    }
                }
            }
        }
    }

    private func metricBlock(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(CSColor.textPrimary)
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(CSColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Action

    private var actionButton: some View {
        Group {
            if deal.escrowStatus == .inTransit {
                CSPrimaryButton("I'm Here — Ready for Exchange", icon: "checkmark.shield.fill") {
                    Task {
                        await EscrowService.shared.markReady(deal: deal)
                        HapticsService.shared.playSuccess()
                    }
                }
            } else if deal.escrowStatus == .readyForExchange {
                CSPrimaryButton("Open POS Terminal", icon: "qrcode") {
                    coordinator.openTerminal(for: deal)
                }
            } else {
                CSPrimaryButton("Simulate Approach", icon: "arrow.triangle.2.circlepath") {
                    simulateApproach()
                }
            }
        }
    }

    private func simulateApproach() {
        guard !isSimulating else { return }
        isSimulating = true
        Task {
            var d = distanceMeters
            var m = minutesRemaining
            while d > 0 {
                try? await Task.sleep(for: .seconds(1))
                d = max(0, d - Int.random(in: 60...150))
                m = max(0, m - 1)
                buyerProgress = min(1, 1 - Double(d) / 1000)
                distanceMeters = d
                minutesRemaining = m
                await LiveActivityService.shared.updateActivity(deal: deal, distanceMeters: d, minutesRemaining: m)
            }
            // Auto-mark ready when arrived
            await EscrowService.shared.startMeetup(deal: deal)
            isSimulating = false
        }
    }
}

// MARK: - Formatting update
