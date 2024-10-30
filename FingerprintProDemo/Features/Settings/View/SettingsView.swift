import SwiftUI

struct SettingsView: View {

    private enum Route: Hashable {
        case apiKeys
    }

    @State private var navigationPath = NavigationPath()

    @StateObject private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                section(titled: "Request") {
                    SettingButton(
                        "Custom API Keys",
                        systemImage: "key.horizontal",
                        accessoryType: .disclosureIndicator(
                            textKey: viewModel.apiKeysEnabled ? "On" : "Off"
                        )
                    ) {
                        navigationPath.append(Route.apiKeys)
                    }
                }
            }
            .background(.backgroundGray)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .apiKeys: CustomApiKeysView()
                }
            }
            .onAppear {
                viewModel.viewDidAppear()
            }
        }
        .tint(.accent)
    }
}

private extension SettingsView {

    @ViewBuilder
    func section<Content: View>(
        titled titleKey: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Section(
            content: content,
            header: {
                Text(titleKey)
                    .font(.inter(size: 16.0, weight: .semibold))
                    .foregroundStyle(.textBlack)
            }
        )
        .textCase(.none)
    }
}

// MARK: Previews

#if DEBUG

#Preview {
    SettingsView(viewModel: .preview)
}

#endif
