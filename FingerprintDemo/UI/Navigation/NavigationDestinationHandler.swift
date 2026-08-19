import SwiftUI

@MainActor
struct NavigationDestinationHandler<R: Route> {

    private let _destination: (R) -> AnyView

    init<V: View>(@ViewBuilder _ destination: @escaping (R) -> V) {
        self._destination = { route in
            AnyView(erasing: destination(route))
        }
    }

    func destination(for route: R) -> AnyView {
        _destination(route)
    }
}
