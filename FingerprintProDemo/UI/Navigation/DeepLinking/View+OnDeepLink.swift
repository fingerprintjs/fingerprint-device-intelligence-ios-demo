import SwiftUI

@MainActor
extension View {

    func onDeepLink<R: Route>(to routeType: R.Type, perform action: @escaping (R) -> Void) -> some View {
        modifier(DeepLinkNavigator.OnDeepLinkModifier(action: action))
    }
}
