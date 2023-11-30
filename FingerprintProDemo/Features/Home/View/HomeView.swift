import SwiftUI

struct HomeView: View {

    var body: some View {
        // Used NavigationView instead of newer NavigationStack, as the latter one causes
        // the animated button to run crazy (potential SwiftUI bug).
        NavigationView {
            VStack(spacing: 32.0) {
                Spacer()
                Text("Tap to begin")
                    .font(.inter(size: 20.0, weight: .semibold))
                Button(
                    action: {},
                    label: {
                        Image("Button/FingerprintImage")
                    }
                )
                .buttonStyle(.fingerprint)
                .padding(.bottom, 96.0)
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Link(destination: C.URLs.documentation) {
                            Label("Documentation", systemImage: "book")
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
        .navigationViewStyle(.stack)
    }
}

#Preview {
    HomeView()
}
