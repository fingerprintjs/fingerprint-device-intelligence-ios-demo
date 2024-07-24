import SwiftUI

struct SettingsView: View {

    var body: some View {
        NavigationStack {
            VStack {
                EmptyView()
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: Previews

#if DEBUG

#Preview {
    SettingsView()
}

#endif
