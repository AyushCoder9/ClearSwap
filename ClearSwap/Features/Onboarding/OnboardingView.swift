import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingCompleted") private var onboardingCompleted = false
    @State private var currentPage = 0
    @State private var animateIn = false

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            accentColor: Color(red: 0.18, green: 0.78, blue: 0.44),
            title: "Market Intelligence",
            subtitle: "Know Your Price",
            body: "Stop guessing. ClearSwap's real-time bell curve shows exactly what your item is worth across Fair, Good, Mint, and New conditions — backed by historical market data.",
            badge: "Swift Charts"
        ),
        OnboardingPage(
            icon: "checkmark.shield.fill",
            accentColor: Color(red: 0.35, green: 0.55, blue: 0.95),
            title: "Escrow Security",
            subtitle: "Zero Trust Required",
            body: "Funds are locked in escrow before you meet. A cryptographic hash guarantees neither party can be scammed. Watch the meetup approach live on your Lock Screen.",
            badge: "ActivityKit"
        ),
        OnboardingPage(
            icon: "wallet.pass.fill",
            accentColor: Color(red: 0.92, green: 0.72, blue: 0.25),
            title: "Apple Wallet Receipt",
            subtitle: "Proof of Ownership",
            body: "The moment payment is confirmed, a signed Verified Receipt lands in your Apple Wallet — with serial number, warranty period, and a scannable QR for insurance claims.",
            badge: "PassKit"
        )
    ]

    var body: some View {
        ZStack {
            // Background that shifts per page
            LinearGradient(
                colors: [
                    CSColor.background,
                    pages[currentPage].accentColor.opacity(0.12)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: currentPage)

            VStack(spacing: 0) {
                // Page indicator dots
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Capsule()
                            .fill(i == currentPage ? pages[currentPage].accentColor : Color.white.opacity(0.25))
                            .frame(width: i == currentPage ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.4), value: currentPage)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 40)

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        pageContent(pages[i])
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)

                // CTA
                VStack(spacing: 12) {
                    if currentPage < pages.count - 1 {
                        CSPrimaryButton("Continue", icon: "arrow.right") {
                            withAnimation { currentPage += 1 }
                            HapticsService.shared.playTap()
                        }
                        Button("Skip to App") {
                            finishOnboarding()
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(CSColor.textSecondary)
                    } else {
                        CSPrimaryButton("Start Trading Securely", icon: "lock.shield.fill") {
                            finishOnboarding()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }

    @ViewBuilder
    private func pageContent(_ page: OnboardingPage) -> some View {
        VStack(spacing: 32) {
            // Hero icon with glow
            ZStack {
                Circle()
                    .fill(page.accentColor.opacity(0.15))
                    .frame(width: 160, height: 160)
                Circle()
                    .fill(page.accentColor.opacity(0.08))
                    .frame(width: 200, height: 200)
                Image(systemName: page.icon)
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(page.accentColor)
                    .symbolEffect(.pulse)
            }

            // Framework badge
            Text(page.badge)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(page.accentColor.opacity(0.2))
                .foregroundStyle(page.accentColor)
                .clipShape(Capsule())

            VStack(spacing: 12) {
                Text(page.subtitle.uppercased())
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(page.accentColor)
                    .tracking(2)

                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(page.body)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 8)
            }

            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private func finishOnboarding() {
        HapticsService.shared.playSuccess()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            onboardingCompleted = true
        }
    }
}

struct OnboardingPage {
    let icon: String
    let accentColor: Color
    let title: String
    let subtitle: String
    let body: String
    let badge: String
}

// MARK: - Formatting update
