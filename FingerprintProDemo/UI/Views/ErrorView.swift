import SwiftUI

struct ErrorView: View {

    private let systemImage: String
    private let title: LocalizedStringResource
    private let description: LocalizedStringResource
    private let retryAction: () -> Void

    init(
        systemImage: String,
        title: LocalizedStringResource,
        description: LocalizedStringResource,
        retryAction: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.retryAction = retryAction
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
    }
}

#Preview {
    ErrorView(
        systemImage: "exclamationmark.circle",
        title: "That was unexpected...",
        description: "Failed to Fingerprint. Please [contact support](\(C.URLs.support, format: .url)) if this issue persists.",
        retryAction: {}
    )
    .padding(.horizontal, 16.0)
}
