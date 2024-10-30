import SwiftUI

struct CustomApiKeysView: View {

    var body: some View {
        List {
            EmptyView()
        }
        .background(.backgroundGray)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("API Keys")
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: Previews

#if DEBUG

#Preview {
    NavigationStack {
        CustomApiKeysView()
    }
}

#endif
