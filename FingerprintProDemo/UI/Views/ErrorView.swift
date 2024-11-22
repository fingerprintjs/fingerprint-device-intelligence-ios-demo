import SwiftUI

struct ErrorView: View {

    private let systemImage: String
    private let title: AttributedString
    private let description: AttributedString
    private let buttonTitle: String
    private let action: @MainActor () -> Void

    @_disfavoredOverload
    init(
        systemImage: String,
        title: AttributedString,
        description: AttributedString,
        buttonTitle: String,
        action: @escaping @MainActor () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.action = action
    }

    init(
        systemImage: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        buttonTitle: LocalizedStringResource,
        action: @escaping @MainActor () -> Void
    ) {
        self.init(
            systemImage: systemImage,
            title: .init(localized: title),
            description: .init(localized: description),
            buttonTitle: .init(localized: buttonTitle),
            action: action
        )
    }

    var body: some View {
        VStack(spacing: 24.0) {
            Image(systemName: systemImage)
                .font(.system(size: 32.0))
                .foregroundStyle(.gray200)
            VStack(spacing: 8.0) {
                Text(title)
                    .font(.inter(size: 16.0, weight: .medium))
                    .foregroundStyle(.gray900)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text(description)
                    .font(.inter(size: 14.0))
                    .kerning(0.056)
                    .foregroundStyle(.gray600)
                    .multilineTextAlignment(.center)
            }
            Button(buttonTitle, action: action)
                .buttonStyle(.default)
        }
        .tint(.accent)
    }
}

// MARK: Previews

#Preview {
    ErrorView(
        systemImage: "exclamationmark.circle",
        title: AttributedString(
            stringLiteral: "An unexpected error occurred..."
        ),
        description: try! AttributedString(
            markdown: "Please [contact support](\(C.URLs.support)) if this issue persists."
        ),
        buttonTitle: "Try again",
        action: {
            print("retryAction()")
        }
    )
    .padding(.horizontal, 16.0)
}
