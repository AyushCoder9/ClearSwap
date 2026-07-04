import CoreHaptics
import SwiftUI

@MainActor
final class HapticsService {
    static let shared = HapticsService()

    private var engine: CHHapticEngine?
    @AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true

    init() {
        prepareEngine()
    }

    private func prepareEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            engine = nil
        }
    }

    func playSuccess() {
        guard hapticsEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        playPattern(intensity: 0.9, sharpness: 0.5, duration: 0.15)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            self.playPattern(intensity: 1.0, sharpness: 0.8, duration: 0.1)
        }
    }

    func playTap() {
        guard hapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func playWalletAdd() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics, let engine else {
            let n = UINotificationFeedbackGenerator()
            n.notificationOccurred(.success)
            return
        }
        // Apple Pay pattern: Tap(0s) → Tap(0.12s) → Sustained(0.24s, 0.3s)
        let tap1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0
        )
        let tap2 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            ],
            relativeTime: 0.12
        )
        let rumble = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
            ],
            relativeTime: 0.24,
            duration: 0.3
        )
        do {
            let pattern = try CHHapticPattern(events: [tap1, tap2, rumble], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            let n = UINotificationFeedbackGenerator()
            n.notificationOccurred(.success)
        }
    }

    private func playPattern(intensity: Float, sharpness: Float, duration: TimeInterval) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine else { return }
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
            ],
            relativeTime: 0,
            duration: duration
        )
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            // Fallback already handled by UIKit generators
        }
    }
}
