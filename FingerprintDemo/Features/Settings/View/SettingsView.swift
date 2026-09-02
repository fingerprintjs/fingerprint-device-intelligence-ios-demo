import SwiftUI

struct SettingsView: View {

    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                otherSection
            }
            .background(.backgroundGray)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
        .tint(.accent)
    }
}

private extension SettingsView {

    @ViewBuilder
    var otherSection: some View {
        section(titled: "Other") {
            SettingButton(
                "Write a Review",
                systemImage: "star",
                action: {
                    openURL(C.URLs.writeReview)
                }
            )
            SettingButton(
                "Privacy Policy",
                systemImage: "hand.raised",
                action: {
                    openURL(C.URLs.privacyPolicy)
                }
            )
        } footer: {
            Text(
                """
                App \(AppInfo.appVersionString) · \
                Fingerprint SDK \(AppInfo.sdkVersionString)
                """
            )
            .frame(maxWidth: .infinity, alignment: .top)
            .font(.inter(size: 14.0))
            .kerning(0.14)
            .foregroundStyle(.gray500)
            .multilineTextAlignment(.center)
            .padding(.top, 4.0)
        }
    }

    @ViewBuilder
    func section<Content: View, Footer: View>(
        titled titleKey: LocalizedStringKey,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer = { EmptyView() }
    ) -> some View {
        Section(
            content: content,
            header: {
                Text(titleKey)
                    .font(.inter(size: 16.0, weight: .semibold))
                    .foregroundStyle(.textBlack)
            },
            footer: footer
        )
        .textCase(.none)
    }
}

// MARK: Previews

#if DEBUG

#Preview {
    SettingsView()
}

#endif
