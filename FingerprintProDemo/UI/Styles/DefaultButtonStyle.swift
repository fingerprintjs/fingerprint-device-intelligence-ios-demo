import SwiftUI

extension ButtonStyle where Self == DefaultButtonStyle {

    static var `default`: Self { .init() }
}

struct DefaultButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24.0)
            .padding(.vertical, 16.0)
            .font(.inter(size: 16.0, weight: .semibold))
            .foregroundStyle(.background)
            .background(background(for: configuration))
            .clipShape(RoundedRectangle(cornerRadius: 6.0))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)
    }
}

private extension DefaultButtonStyle {

    func background(for configuration: Configuration) -> some ShapeStyle {
        guard isEnabled else {
            return .lightOrange
        }

        return configuration.isPressed ? .darkOrange : .accent
    }
}
