import Lottie
import PassKit
import SwiftUI

struct CheckoutSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let metadata: WalletPassMetadata
    @StateObject private var passKit = PassKitService.shared
    @State private var showAddPass = false
    @State private var animate = false

    var body: some View {
        ZStack {
            TerminalBackground()
            VStack(spacing: 24) {
                Spacer()
                successHeader
                WalletPassPreview(metadata: metadata)
                    .padding(.horizontal)
                    .scaleEffect(animate ? 1 : 0.9)
                    .opacity(animate ? 1 : 0)

                if let pass = passKit.lastPass, passKit.canAddToWallet {
                    CSPrimaryButton("Add to Apple Wallet", icon: "wallet.pass.fill") {
                        showAddPass = true
                    }
                    .padding(.horizontal)
                } else {
                    CSPrimaryButton("Save Receipt", icon: "checkmark.seal.fill") {
                        saveReceiptRecord(walletAdded: false)
                        dismiss()
                    }
                    .padding(.horizontal)
                    CSTypography.caption("PassKit signing requires Apple Developer certs. Preview shown.")
                }

                Button("Done") {
                    saveReceiptRecord(walletAdded: passKit.lastPass != nil)
                    dismiss()
                }
                .foregroundStyle(CSColor.textSecondary)

                Spacer()
            }
        }
        .onAppear {
            _ = passKit.buildPass(from: metadata)
            withAnimation(.spring(duration: 0.6)) { animate = true }
            HapticsService.shared.playSuccess()
        }
        .sheet(isPresented: $showAddPass) {
            if let pass = passKit.lastPass {
                AddPassViewControllerRepresentable(pass: pass) {
                    saveReceiptRecord(walletAdded: true)
                    showAddPass = false
                }
            }
        }
    }

    private var successHeader: some View {
        VStack(spacing: 12) {
            LottieView(animation: .named("success_confetti"))
                .playing(loopMode: .playOnce)
                .frame(width: 160, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            CSTypography.largeTitle("Payment Confirmed")
            CSTypography.body("Your verified receipt is ready for Apple Wallet")
        }
    }

    private func saveReceiptRecord(walletAdded: Bool) {
        // Receipt already inserted during checkout; update if needed
        HapticsService.shared.playTap()
    }
}
