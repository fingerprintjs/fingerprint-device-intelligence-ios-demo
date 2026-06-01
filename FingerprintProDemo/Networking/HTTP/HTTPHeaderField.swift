enum HTTPHeaderField: Hashable {
    case accept(String)
    case basicAuthorization(String)
    case custom(name: String, value: String)
}

extension HTTPHeaderField {

    var name: String {
        switch self {
        case .accept: "Accept"
        case .basicAuthorization: "Authorization"
        case let .custom(name, _): name
        }
    }

    var value: String {
        switch self {
        case let .accept(value): value
        case let .basicAuthorization(value): "Basic \(value)"
        case let .custom(_, value): value
        }
    }
}
