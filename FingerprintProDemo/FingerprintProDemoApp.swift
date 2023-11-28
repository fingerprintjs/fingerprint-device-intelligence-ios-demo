import SwiftUI

@main
struct FingerprintProDemoApp: App {

    var body: some Scene {
        WindowGroup {
            VStack {
                Spacer()
                Button(
                    action: {},
                    label: {
                        Image("Button/FingerprintImage")
                    }
                )
                .buttonStyle(.fingerprint)
                .padding(.bottom, 96.0)
            }
        }
    }
}
