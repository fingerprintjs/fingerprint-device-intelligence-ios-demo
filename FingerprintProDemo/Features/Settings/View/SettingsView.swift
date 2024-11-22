import SwiftUI

struct SettingsView: View {

    private typealias Route = SettingsRoute

    @Environment(\.openURL) private var openURL

    @State private var navigationPath: [Route] = []

    @StateObject private var viewModel: SettingsViewModel
    private let navigationDestinationHandler: SettingsNavigationDestinationHandler

    init(
        viewModel: SettingsViewModel,
        navigationDestinationHandler: SettingsNavigationDestinationHandler
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.navigationDestinationHandler = navigationDestinationHandler
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                requestSection
                otherSection
            }
            .background(.backgroundGray)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .navigationDestination(
                for: Route.self,
                destination: navigationDestinationHandler.destination(for:)
            )
            .onAppear {
                viewModel.viewDidAppear()
            }
        }
        .onDeepLink(to: Route.self) { route in
            navigationPath = [route]
        }
        .tint(.accent)
    }
}

private extension SettingsView {

    @ViewBuilder
    var requestSection: some View {
        section(titled: "Request") {
            SettingButton(
                "API Keys",
                systemImage: "key.horizontal",
                accessoryType: .disclosureIndicator(
                    textKey: viewModel.apiKeysEnabled ? "On" : "Off"
                )
            ) {
                navigationPath.append(.apiKeys)
            }
        }
    }

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
    SettingsView(
        viewModel: .preview,
        navigationDestinationHandler: .preview
    )
}

#endif
