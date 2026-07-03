import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var escrowService = EscrowService.shared
    @State private var showEscrowError = false

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            NavigationStack {
                SellerDashboardView()
            }
            .tabItem { Label("Deals", systemImage: "terminal.fill") }
            .tag(AppCoordinator.AppTab.dashboard)

            NavigationStack {
                ValuationStudioView()
            }
            .tabItem { Label("Pricing", systemImage: "chart.line.uptrend.xyaxis") }
            .tag(AppCoordinator.AppTab.valuation)

            NavigationStack {
                TransactionArchiveView()
            }
            .tabItem { Label("Archive", systemImage: "archivebox.fill") }
            .tag(AppCoordinator.AppTab.archive)

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(AppCoordinator.AppTab.settings)
        }
        .tint(CSColor.accent)
        .sheet(item: $coordinator.presentedDeal) { deal in
            if coordinator.activeRole == .seller {
                POSTerminalView(deal: deal)
            } else {
                BuyerCheckoutView(deal: deal)
            }
        }
        .fullScreenCover(isPresented: $coordinator.showCheckoutSuccess) {
            if let metadata = coordinator.checkoutMetadata {
                CheckoutSuccessView(metadata: metadata)
            }
        }
        .alert("Escrow Error", isPresented: $showEscrowError) {
            Button("OK", role: .cancel) { escrowService.clearError() }
        } message: {
            Text(escrowService.lastError ?? "An unknown error occurred.")
        }
        .onChange(of: escrowService.lastError) { _, newValue in
            showEscrowError = newValue != nil
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @AppStorage("onboardingCompleted") private var onboardingCompleted = true
    @AppStorage("hapticsEnabled") private var hapticsEnabled = true
    @Environment(\.modelContext) private var modelContext
    @State private var showClearDataAlert = false
    @State private var showResetOnboardingConfirm = false

    var body: some View {
        ZStack {
            TerminalBackground()
            List {
                Section("Demo Mode") {
                    Picker("Active Role", selection: $coordinator.activeRole) {
                        Text("Seller").tag(UserRole.seller)
                        Text("Buyer").tag(UserRole.buyer)
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(CSColor.surface)
                }

                Section("Preferences") {
                    Toggle(isOn: $hapticsEnabled) {
                        Label("Haptic Feedback", systemImage: "waveform")
                    }
                    .tint(CSColor.accent)
                    .listRowBackground(CSColor.surface)
                }

                Section("Apple Integrations") {
                    HStack {
                        Label("Live Activities", systemImage: "lock.fill")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(CSColor.accent)
                    }
                    HStack {
                        Label("PassKit Wallet", systemImage: "wallet.pass.fill")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(CSColor.accent)
                    }
                    HStack {
                        Label("App Intents / Siri", systemImage: "mic.fill")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(CSColor.accent)
                    }
                    HStack {
                        Label("Core Haptics", systemImage: "waveform")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(CSColor.accent)
                    }
                }
                .listRowBackground(CSColor.surface)

                Section("Data") {
                    Button(role: .destructive) {
                        showClearDataAlert = true
                    } label: {
                        Label("Clear All Deal Data", systemImage: "trash")
                    }
                    .listRowBackground(CSColor.surface)

                    Button {
                        showResetOnboardingConfirm = true
                    } label: {
                        Label("Reset Onboarding", systemImage: "arrow.counterclockwise")
                            .foregroundStyle(CSColor.warning)
                    }
                    .listRowBackground(CSColor.surface)
                }

                Section("About") {
                    LabeledContent("Version", value: "1.0.0")
                    LabeledContent("Platform", value: "iOS 18+")
                    LabeledContent("Architecture", value: "MVVM-C + Swift 6")
                    LabeledContent("Concurrency", value: "Strict")
                }
                .listRowBackground(CSColor.surface)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .alert("Clear All Data?", isPresented: $showClearDataAlert) {
            Button("Clear", role: .destructive) { clearAllData() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all deals and receipts. This cannot be undone.")
        }
        .alert("Reset Onboarding?", isPresented: $showResetOnboardingConfirm) {
            Button("Reset", role: .destructive) { onboardingCompleted = false }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("You will see the onboarding flow on next launch.")
        }
    }

    private func clearAllData() {
        try? modelContext.delete(model: Deal.self)
        try? modelContext.delete(model: ReceiptRecord.self)
        try? modelContext.delete(model: ItemValuation.self)
        HapticsService.shared.playTap()
    }
}
