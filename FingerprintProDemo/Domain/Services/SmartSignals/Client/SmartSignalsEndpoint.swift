import Foundation

enum SmartSignalsEndpoint: URLConvertibleEndpoint {

    case event(requestId: String)

    var baseURL: URL {
        get throws {
            guard let url = ConfigVariable.SmartSignals.baseURL else {
                throw NetworkingError.invalidURL(url: self)
            }

            return url
        }
    }

    var path: String {
        switch self {
        case let .event(requestId): "/event/\(requestId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .event: .get
        }
    }

    var headerFields: Set<HTTPHeaderField> {
        var fields: Set<HTTPHeaderField> = [
            .accept("application/json")
        ]
        if let origin = ConfigVariable.SmartSignals.origin.map(HTTPHeaderField.origin) {
            fields.insert(origin)
        }

        return fields
    }
}
