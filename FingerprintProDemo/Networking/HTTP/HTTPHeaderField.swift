enum HTTPHeaderField: Hashable {
    case accept(String)
    case origin(String)
    case custom(name: String, value: String)
}

extension HTTPHeaderField {

    var name: String {
        switch self {
        case .accept: "Accept"
        case .origin: "Origin"
        case let .custom(name, _): name
        }
    }

    var value: String {
        switch self {
        case let .accept(value): value
        case let .origin(value): value
        case let .custom(_, value): value
        }
    }
}
