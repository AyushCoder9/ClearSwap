import SwiftData
import SwiftUI

struct SellerDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var coordinator: AppCoordinator
    @Query(sort: \Deal.createdAt, order: .reverse) private var deals: [Deal]
    @StateObject private var escrowService = EscrowService.shared

    private var activeDeals: [Deal] {
        deals.filter { !$0.escrowStatus.isTerminal }
    }

    var body: some View {
        ZStack {
            TerminalBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    escrowSummary
                    roleBanner
                    dealsSection
                }
                .padding()
            }
        }
        .navigationTitle("ClearSwap")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NewDealView()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(CSColor.accent)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            CSTypography.caption("ESCROW TERMINAL")
            CSTypography.largeTitle("Active Deals")
        }
    }

    private var escrowSummary: some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    CSTypography.caption("LOCKED IN ESCROW")
                    Text(CurrencyFormatting.string(from: escrowService.totalLockedAmount(deals: activeDeals)))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(CSColor.accent)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.title)
                        .foregroundStyle(CSColor.accent)
                    CSTypography.caption("\(activeDeals.count) active")
                }
            }
        }
    }

    private var roleBanner: some View {
        GlassCard {
            HStack {
                Image(systemName: coordinator.activeRole == .seller ? "storefront.fill" : "bag.fill")
                    .foregroundStyle(CSColor.accent)
                VStack(alignment: .leading) {
                    CSTypography.headline(coordinator.activeRole == .seller ? "Seller Mode" : "Buyer Mode")
                    CSTypography.caption(
                        coordinator.activeRole == .seller
                            ? "Tap a deal to open POS terminal"
                            : "Tap a deal to scan & pay"
                    )
                }
                Spacer()
            }
        }
    }

    private var dealsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            CSTypography.headline("Deal Feed")
            if activeDeals.isEmpty {
                GlassCard {
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundStyle(CSColor.textSecondary)
                        CSTypography.body("No active deals. Create one from Pricing or tap +.")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            } else {
                ForEach(activeDeals) { deal in
                    DealCardView(deal: deal) {
                        HapticsService.shared.playTap()
                        coordinator.openTerminal(for: deal)
                    } onFund: {
                        Task { await escrowService.fundEscrow(deal: deal) }
                    } onMeetup: {
                        Task {
                            await escrowService.startMeetup(deal: deal)
                            await LiveActivityService.shared.startMeetupActivity(for: deal)
                        }
                    }
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .slide))
                }
            }
        }
    }
}

struct DealCardView: View {
    let deal: Deal
    let onTap: () -> Void
    let onFund: () -> Void
    let onMeetup: () -> Void

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Image(systemName: deal.imageSystemName)
                        .font(.title2)
                        .foregroundStyle(CSColor.accent)
                        .frame(width: 44, height: 44)
                        .background(CSColor.accent.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        CSTypography.headline(deal.itemTitle)
                        CSTypography.caption("\(deal.category) · \(deal.condition.displayName)")
                        CSTypography.caption("Buyer: \(deal.buyerName)")
                    }
                    Spacer()
                    CSStatusBadge(status: deal.escrowStatus)
                }

                HStack {
                    Text(CurrencyFormatting.string(from: deal.agreedPrice))
                        .font(.title3.bold())
                        .foregroundStyle(CSColor.textPrimary)
                    Spacer()
                    CSTypography.caption(deal.meetupLocation.name)
                }

                HStack(spacing: 8) {
                    if deal.escrowStatus == .draft || deal.escrowStatus == .priceLocked {
                        Button("Fund Escrow", action: onFund)
                            .buttonStyle(.borderedProminent)
                            .tint(CSColor.accentMuted)
                    }
                    if deal.escrowStatus == .escrowFunded {
                        Button("Start Meetup", action: onMeetup)
                            .buttonStyle(.borderedProminent)
                            .tint(CSColor.accent)
                    }
                    Button(deal.escrowStatus == .readyForExchange ? "Open Terminal" : "View", action: onTap)
                        .buttonStyle(.bordered)
                        .tint(CSColor.accent)
                }
                .font(.caption.bold())
            }
        }
        .buttonStyle(InteractiveCardStyle())
    }
}
