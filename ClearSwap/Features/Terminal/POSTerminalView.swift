import SwiftData
import SwiftUI

struct POSTerminalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var deal: Deal
    @State private var qrPayload = ""
    @State private var pulse = false
    @State private var brightnessBoosted = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                header
                Spacer()
                qrSection
                Spacer()
                footer
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(false)
        .onAppear {
            prepareTerminal()
            boostBrightness()
        }
        .onDisappear {
            restoreBrightness()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                CSStatusBadge(status: deal.escrowStatus)
                Spacer()
                Button("Close") { dismiss() }
                    .foregroundStyle(CSColor.textSecondary)
            }
            CSTypography.title("Receive Payment")
            CSTypography.body(deal.itemTitle)
        }
    }

    private var qrSection: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .stroke(CSColor.accent, lineWidth: 2)
                    .frame(width: 280, height: 280)
                    .scaleEffect(pulse ? 1.5 : 1.0)
                    .opacity(pulse ? 0 : 0.8)
                    .animation(
                        .easeOut(duration: 2.0)
                        .repeatForever(autoreverses: false)
                        .delay(Double(i) * 0.6),
                        value: pulse
                    )
            }

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white)
                .frame(width: 260, height: 260)
                .overlay {
                    if qrPayload.isEmpty {
                        ProgressView()
                    } else {
                        QRCodeView(payload: qrPayload)
                            .padding(20)
                    }
                }
        }
        .onAppear { pulse = true }
    }

    private var footer: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    CSTypography.caption("AMOUNT")
                    Text(CurrencyFormatting.string(from: deal.agreedPrice))
                        .font(.title.bold())
                        .foregroundStyle(CSColor.accent)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    CSTypography.caption("BUYER")
                    CSTypography.headline(deal.buyerName)
                }
            }
            .padding()
            .background(CSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Label("Escrow verified · Tap via NFC / App Clip", systemImage: "wave.3.right")
                .font(.caption)
                .foregroundStyle(CSColor.textSecondary)
                .shimmer()

            Button("Mark Ready for Exchange") {
                Task {
                    await EscrowService.shared.markReady(deal: deal)
                    refreshQR()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(CSColor.accent)
        }
    }

    private func prepareTerminal() {
        Task {
            if deal.releaseHash == nil {
                await EscrowService.shared.fundEscrow(deal: deal)
            }
            if deal.escrowStatus == .escrowFunded || deal.escrowStatus == .inTransit {
                await EscrowService.shared.markReady(deal: deal)
            }
            refreshQR()
        }
    }

    private func refreshQR() {
        let hash = deal.releaseHash ?? UUID().uuidString.prefix(8).uppercased()
        deal.releaseHash = String(hash)
        let payload = QRCodeService.payload(for: deal, hash: String(hash))
        qrPayload = payload.encodedString() ?? ""
        try? modelContext.save()
    }

    private func boostBrightness() {
        brightnessBoosted = true
        UIScreen.main.brightness = 1.0
    }

    private func restoreBrightness() {
        if brightnessBoosted {
            UIScreen.main.brightness = 0.5
        }
    }
}

struct BuyerCheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var coordinator: AppCoordinator
    @Bindable var deal: Deal
    @State private var scannedPayload = ""
    @State private var isProcessing = false
    @State private var errorMessage: String?
    @State private var showScanner = false

    var body: some View {
        NavigationStack {
            ZStack {
                TerminalBackground()
                VStack(spacing: 20) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            CSTypography.headline(deal.itemTitle)
                            CSTypography.body("Pay \(CurrencyFormatting.string(from: deal.agreedPrice)) to \(deal.sellerName)")
                            CSStatusBadge(status: deal.escrowStatus)
                        }
                    }

                    CSPrimaryButton("Simulate QR Scan", icon: "qrcode.viewfinder") {
                        simulateScan()
                    }

                    if isProcessing {
                        ProgressView("Authorizing...")
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(CSColor.danger)
                            .font(.caption)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func simulateScan() {
        isProcessing = true
        errorMessage = nil
        Task {
            do {
                let hash = deal.releaseHash ?? "DEMOHASH"
                let authenticated = try await BiometricService.authenticate(
                    reason: "Release \(CurrencyFormatting.string(from: deal.agreedPrice)) from escrow"
                )
                guard authenticated else {
                    errorMessage = "Biometric authentication failed."
                    isProcessing = false
                    return
                }

                try await EscrowService.shared.releaseFunds(dealID: deal.id, hash: hash)
                deal.escrowStatus = .completed
                deal.completedAt = .now

                let receipt = ReceiptRecord(
                    dealID: deal.id,
                    itemTitle: deal.itemTitle,
                    amountPaid: deal.agreedPrice,
                    serialNumber: deal.serialNumber,
                    sellerName: deal.sellerName,
                    buyerName: deal.buyerName
                )
                modelContext.insert(receipt)
                try? modelContext.save()

                await LiveActivityService.shared.endActivity()
                HapticsService.shared.playWalletAdd()

                let metadata = WalletPassMetadata(
                    dealID: deal.id,
                    itemTitle: deal.itemTitle,
                    serialNumber: deal.serialNumber,
                    amountPaid: deal.agreedPrice,
                    sellerName: deal.sellerName,
                    buyerName: deal.buyerName,
                    purchaseDate: .now,
                    warrantyExpires: Calendar.current.date(byAdding: .day, value: 30, to: .now) ?? .now
                )

                dismiss()
                coordinator.completeCheckout(metadata: metadata)
            } catch {
                errorMessage = error.localizedDescription
            }
            isProcessing = false
        }
    }
}

// MARK: - Formatting update
