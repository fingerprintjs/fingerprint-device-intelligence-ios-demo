import SwiftUI

struct HomeView: View {

    private enum VisualState: Equatable {
        case tapToBegin
        case deviceFingerprint
    }

    @State private var state: VisualState = .tapToBegin

    @StateObject private var deviceFingerprintViewModel: DeviceFingerprintViewModel

    init(deviceFingerprintViewModel: DeviceFingerprintViewModel) {
        self._deviceFingerprintViewModel = .init(wrappedValue: deviceFingerprintViewModel)
    }

    var body: some View {
        // Used NavigationView instead of newer NavigationStack, as the latter one causes
        // the animated button to run crazy (potential SwiftUI bug).
        NavigationView {
            VStack(spacing: .zero) {
                switch state {
                case .tapToBegin:
                    startupView
                case .deviceFingerprint:
                    DeviceFingerprintView(
                        presentation: .extendedResponse,
                        viewModel: deviceFingerprintViewModel
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
            .padding(.bottom, 32.0)
        Button(
            action: {
                state = .deviceFingerprint
            },
            label: {
                Image("Button/FingerprintImage")
            }
        )
        .buttonStyle(.fingerprint)
        .padding(.bottom, 40.0)
        Text(
              """
              Device intelligence powered by
              Fingerprint iOS SDK \(AppInfo.sdkVersionString)
              """
        )
        .font(.inter(size: 14.0))
        .kerning(0.14)
        .foregroundStyle(.mediumGray)
        .multilineTextAlignment(.center)
        .padding(.bottom, 64.0)
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

#if DEBUG

#Preview {
    HomeView(deviceFingerprintViewModel: .preview)
}

#endif
