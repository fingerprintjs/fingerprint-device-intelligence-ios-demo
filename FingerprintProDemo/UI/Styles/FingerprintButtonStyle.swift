import SwiftUI

extension ButtonStyle where Self == FingerprintButtonStyle {

    static var fingerprint: Self { .init() }
}

struct FingerprintButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var isEnabled: Bool

    @State private var isAnimating: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 28.0)
            .background(background(for: configuration))
            .clipShape(Circle())
            .scaleEffect(scaleFactor(for: configuration))
            .animation(scaleAnimation, value: isAnimating)
            .animation(pressedAnimation, value: configuration.isPressed)
            .onAppear {
                isAnimating = isEnabled
            }
            .onChange(of: isEnabled) { value in
                isAnimating = value
            }
            .onChange(of: configuration.isPressed) { _ in
                isAnimating = false
            }
    }
}

private extension FingerprintButtonStyle {

    func background(for configuration: Configuration) -> some ShapeStyle {
        guard isEnabled else {
            return .lightOrange
        }

        return configuration.isPressed ? .darkOrange : .accent
    }

    func scaleFactor(for configuration: Configuration) -> CGFloat {
        guard !configuration.isPressed else {
            return 0.9
        }

        return isAnimating ? 1.1 : 1.0
    }
}

private extension FingerprintButtonStyle {

    var scaleAnimation: Animation {
        guard isAnimating else {
            return .linear
        }

        return Animation
            .easeInOut(duration: 0.6)
            .repeatForever()
    }

    var pressedAnimation: Animation {
        .easeOut(duration: 0.25)
    }
}
