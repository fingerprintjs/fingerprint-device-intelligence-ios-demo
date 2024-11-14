protocol Route: Hashable, Sendable {
    var childRoute: (any Route)? { get }
}
