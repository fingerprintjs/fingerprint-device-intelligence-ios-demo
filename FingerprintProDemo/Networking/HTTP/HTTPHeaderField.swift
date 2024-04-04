enum HTTPHeaderField: Hashable {
    case origin(String)
    case custom(name: String, value: String)
}

extension HTTPHeaderField {

    var name: String {
        switch self {
        case .origin:
            return "Origin"
        case let .custom(name, _):
            return name
        }
    }

    var value: String {
        switch self {
        case let .origin(value):
            return value
        case let .custom(_, value):
            return value
        }
    }
}
