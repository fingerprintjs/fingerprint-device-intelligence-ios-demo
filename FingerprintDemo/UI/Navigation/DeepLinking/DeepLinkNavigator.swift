import SwiftUI

extension DeepLinkNavigator {

    nonisolated static let `default`: DeepLinkNavigator = .init()
}

@MainActor
final class DeepLinkNavigator {

    private var routeHandlers: [ObjectIdentifier: any Sendable] = [:]
    private var unhandledRoute: (any Route)?

    nonisolated init() {}

    func callAsFunction<R: Route>(to route: R) {
        unhandledRoute = .none
        handle(route)
    }
}

extension DeepLinkNavigator {

    @MainActor
    struct OnDeepLinkModifier<R: Route>: ViewModifier {

        @Environment(\.deepLink) private var deepLink

        @State private var routeHandler: DeepLinkNavigator.RouteHandler<R>

        init(action: @escaping (R) -> Void) {
            self.routeHandler = .init(action)
        }

        func body(content: Content) -> some View {
            content
                .onAppear {
                    deepLink.register(routeHandler)
                }
                .onDisappear {
                    deepLink.unregister(routeHandler)
                }
        }
    }
}

private extension DeepLinkNavigator {

    @MainActor
    struct RouteHandler<R: Route>: Identifiable {

        let id: UUID = .init()

        private let action: (R) -> Void

        init(_ action: @escaping (R) -> Void) {
            self.action = action
        }

        func handle(_ route: R) -> (any Route)? {
            action(route)
            return route.childRoute
        }
    }

    func register<R: Route>(_ handler: RouteHandler<R>) {
        let key = ObjectIdentifier(R.self)
        routeHandlers[key] = handler
        guard let route = unhandledRoute as? R else { return }
        handle(route)
    }

    func unregister<R: Route>(_ handler: RouteHandler<R>) {
        let key = ObjectIdentifier(R.self)
        guard
            let routeHandler = routeHandlers[key] as? RouteHandler<R>,
            routeHandler.id == handler.id
        else {
            return
        }
        routeHandlers.removeValue(forKey: key)
    }

    func handle<R: Route>(_ route: R) {
        let key = ObjectIdentifier(R.self)
        guard let routeHandler = routeHandlers[key] as? RouteHandler<R> else {
            unhandledRoute = route
            return
        }
        guard let route = routeHandler.handle(route) else {
            unhandledRoute = .none
            return
        }
        handle(route)
    }
}
