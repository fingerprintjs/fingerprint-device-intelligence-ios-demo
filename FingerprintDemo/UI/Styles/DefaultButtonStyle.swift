import SwiftUI

extension ButtonStyle where Self == DefaultButtonStyle {

    static var `default`: Self { .init() }
}

struct DefaultButtonStyle: ButtonStyle {

    @Environment(\.isEnabled) private var isEnabled: Bool

    private let fontSize: CGFloat

    private let backgroundColor: Color
    private let pressedBackgroundColor: Color
    private let disabledBackgroundColor: Color

    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat

    init(
        fontSize: CGFloat = 16.0,
        backgroundColor: Color = .accent,
        pressedBackgroundColor: Color = .darkOrange,
        disabledBackgroundColor: Color = .lightPastelOrange,
        horizontalPadding: CGFloat = 24.0,
        verticalPadding: CGFloat = 16.0
    ) {
        self.fontSize = fontSize
        self.backgroundColor = backgroundColor
        self.pressedBackgroundColor = pressedBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .font(.inter(size: fontSize, weight: .semibold))
            .foregroundStyle(.primaryButtonTitle)
            .background(background(for: configuration))
            .clipShape(RoundedRectangle(cornerRadius: 6.0))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)
    }
}

private extension DefaultButtonStyle {

    func background(for configuration: Configuration) -> some ShapeStyle {
        guard isEnabled else {
            return disabledBackgroundColor
        }

        return configuration.isPressed ? pressedBackgroundColor : backgroundColor
    }
}
