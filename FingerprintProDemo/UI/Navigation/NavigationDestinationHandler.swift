import SwiftUI

@MainActor
struct NavigationDestinationHandler<Route: Hashable> {

    private let _destination: (Route) -> AnyView

    init<V: View>(@ViewBuilder _ destination: @escaping (Route) -> V) {
        self._destination = { route in
            AnyView(erasing: destination(route))
        }
    }

    func destination(for route: Route) -> AnyView {
        _destination(route)
    }
}
