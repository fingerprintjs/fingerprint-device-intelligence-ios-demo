import SwiftUI

struct CallToActionView: View {

    private let title: AttributedString
    private let description: AttributedString

    private let primaryButtonTitle: String
    private let primaryAction: @MainActor () -> Void

    private let secondaryButtonTitle: String
    private let secondaryAction: @MainActor () -> Void

    @_disfavoredOverload
    init(
        title: AttributedString,
        description: AttributedString,
        primaryButtonTitle: String,
        primaryAction: @escaping @MainActor () -> Void,
        secondaryButtonTitle: String,
        secondaryAction: @escaping @MainActor () -> Void
    ) {
        self.title = title
        self.description = description
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryAction = secondaryAction
    }

    init(
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        primaryButtonTitle: LocalizedStringResource,
        primaryAction: @escaping @MainActor () -> Void,
        secondaryButtonTitle: LocalizedStringResource,
        secondaryAction: @escaping @MainActor () -> Void
    ) {
        self.init(
            title: .init(localized: title),
            description: .init(localized: description),
            primaryButtonTitle: .init(localized: primaryButtonTitle),
            primaryAction: primaryAction,
            secondaryButtonTitle: .init(localized: secondaryButtonTitle),
            secondaryAction: secondaryAction
        )
    }

    var body: some View {
        VStack(spacing: 24.0) {
            VStack(spacing: 4.0) {
                Text(title)
                    .font(.inter(size: 16.0, weight: .semibold))
                    .foregroundStyle(.gray900)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text(description)
                    .font(.inter(size: 14.0))
                    .kerning(0.056)
                    .foregroundStyle(.gray600)
                    .multilineTextAlignment(.center)
            }
            VStack(spacing: 16.0) {
                Button(
                    action: primaryAction,
                    label: {
                        Text(primaryButtonTitle)
                            .frame(maxWidth: .infinity)
                    }
                )
                .buttonStyle(
                    DefaultButtonStyle(
                        fontSize: 14.0,
                        backgroundColor: .gray900,
                        pressedBackgroundColor: .backgroundBlack,
                        disabledBackgroundColor: .gray600,
                        verticalPadding: 10.0
                    )
                )
                Button(
                    action: secondaryAction,
                    label: {
                        Text(secondaryButtonTitle)
                            .font(.inter(size: 14.0))
                            .kerning(0.14)
                            .foregroundStyle(.secondaryButtonTitle)
                            .multilineTextAlignment(.center)
                    }
                )
                .buttonStyle(.plain)
            }
        }
        .padding(.all, 16.0)
        .background(.backgroundGray)
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
    }
}

// MARK: Previews

#Preview {
    CallToActionView(
        title: AttributedString(
            stringLiteral: "Impressed with Fingerprint?"
        ),
        description: AttributedString(
            stringLiteral: "Check our website for more info."
        ),
        primaryButtonTitle: "Learn more",
        primaryAction: {
            print("primaryAction()")
        },
        secondaryButtonTitle: "Don’t show again for a week",
        secondaryAction: {
            print("secondaryAction()")
        }
    )
    .padding(.horizontal, 16.0)
}
