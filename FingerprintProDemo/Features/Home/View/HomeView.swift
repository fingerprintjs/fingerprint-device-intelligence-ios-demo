import SwiftUI
import FingerprintPro

struct HomeView: View {

    private enum VisualState: Equatable {
        case tapToBegin
        case deviceFingerprint
    }

    @State private var state: VisualState = .tapToBegin

    private let identificationService: any DeviceIdentificationServiceProtocol

    init(identificationService: any DeviceIdentificationServiceProtocol) {
        self.identificationService = identificationService
    }

    var body: some View {
        // Used NavigationView instead of newer NavigationStack, as the latter one causes
        // the animated button to run crazy (potential SwiftUI bug).
        NavigationView {
            VStack(spacing: 32.0) {
                switch state {
                case .tapToBegin:
                    startupView
                case .deviceFingerprint:
                    DeviceFingerprintView(
                        presentation: .extendedResponse,
                        viewModel: .init(
                            identificationService: identificationService
                        )
                    )
                }
            }
            .animation(.easeInOut(duration: 0.25).delay(0.15), value: state)
            .toolbar {
                toolbarContent
            }
        }
        .tint(.accent)
        .navigationViewStyle(.stack)
    }
}

private extension HomeView {

    @ViewBuilder
    var startupView: some View {
        Spacer()
        Text("Tap to begin")
            .font(.inter(size: 20.0, weight: .semibold))
        Button(
            action: {
                state = .deviceFingerprint
            },
            label: {
                Image("Button/FingerprintImage")
            }
        )
        .buttonStyle(.fingerprint)
        .padding(.bottom, 96.0)
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Menu {
                Link(destination: C.URLs.documentation) {
                    Label("Documentation", systemImage: "book")
                }
                Link(destination: C.URLs.privacyPolicy) {
                    Label("Privacy Policy", systemImage: "hand.raised")
                }
                Link(destination: C.URLs.support) {
                    Label("Support", systemImage: "message")
                }
            } label: {
                Label("More", systemImage: "ellipsis.circle")
            }
        }
    }
}

// MARK: Previews

#Preview {
    HomeView(identificationService: .default)
}
