import SwiftUI

struct ErrorView: View {

    private let systemImage: String
    private let title: AttributedString
    private let description: AttributedString
    private let retryAction: () -> Void

    @_disfavoredOverload
    init(
        systemImage: String,
        title: AttributedString,
        description: AttributedString,
        retryAction: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.retryAction = retryAction
    }

    init(
        systemImage: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        retryAction: @escaping () -> Void
    ) {
        self.init(
            systemImage: systemImage,
            title: .init(localized: title),
            description: .init(localized: description),
            retryAction: retryAction
        )
    }

    var body: some View {
        VStack(spacing: 24.0) {
            Image(systemName: systemImage)
                .font(.system(size: 32.0))
                .foregroundStyle(.extraLightGray)
            VStack(spacing: 8.0) {
                Text(title)
                    .font(.inter(size: 16.0, weight: .medium))
                    .foregroundStyle(.extraDarkGray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Text(description)
                    .font(.inter(size: 14.0))
                    .kerning(0.056)
                    .foregroundStyle(.semiDarkGray)
                    .multilineTextAlignment(.center)
            }
            Button("Try again", action: retryAction)
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
        retryAction: {
            print("retryAction()")
        }
    )
    .padding(.horizontal, 16.0)
}
