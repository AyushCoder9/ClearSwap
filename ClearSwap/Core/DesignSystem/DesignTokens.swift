import SwiftUI

enum CSColor {
    static let background = Color(red: 0.06, green: 0.08, blue: 0.10)
    static let surface = Color(red: 0.10, green: 0.13, blue: 0.16)
    static let surfaceElevated = Color(red: 0.14, green: 0.17, blue: 0.21)
    static let accent = Color(red: 0.18, green: 0.78, blue: 0.44)
    static let accentMuted = Color(red: 0.12, green: 0.45, blue: 0.30)
    static let warning = Color(red: 0.95, green: 0.72, blue: 0.25)
    static let danger = Color(red: 0.92, green: 0.30, blue: 0.28)
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.65)
    static let glassStroke = Color.white.opacity(0.12)
    static let terminalGlow = Color(red: 0.18, green: 0.78, blue: 0.44).opacity(0.35)
}

enum CSTypography {
    static func largeTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .foregroundStyle(CSColor.textPrimary)
    }

    static func title(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .foregroundStyle(CSColor.textPrimary)
    }

    static func headline(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(CSColor.textPrimary)
    }

    static func body(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15, weight: .regular, design: .rounded))
            .foregroundStyle(CSColor.textSecondary)
    }

    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundStyle(CSColor.textSecondary)
    }

    static func mono(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .medium, design: .monospaced))
            .foregroundStyle(CSColor.textPrimary)
    }
}

struct GlassCard<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
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
}

struct InteractiveCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var isInitialState = true

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.45), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .rotationEffect(.degrees(20))
                    .offset(x: isInitialState ? -geo.size.width : geo.size.width)
                    .animation(
                        .linear(duration: 1.8).repeatForever(autoreverses: false),
                        value: isInitialState
                    )
                }
                .mask { content }
            }
            .onAppear { isInitialState = false }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

struct CSPrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(CSColor.accent.gradient)
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct CSStatusBadge: View {
    let status: EscrowStatus

    var body: some View {
        Text(status.displayTitle.uppercased())
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundStyle(badgeColor)
            .clipShape(Capsule())
    }

    private var badgeColor: Color {
        switch status {
        case .escrowFunded, .readyForExchange, .completed, .released:
            CSColor.accent
        case .inTransit, .releasing:
            CSColor.warning
        case .cancelled, .disputed:
            CSColor.danger
        default:
            CSColor.textSecondary
        }
    }
}

struct TerminalBackground: View {
    var body: some View {
        ZStack {
            CSColor.background.ignoresSafeArea()
            RadialGradient(
                colors: [CSColor.terminalGlow, .clear],
                center: .center,
                startRadius: 20,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }
}
