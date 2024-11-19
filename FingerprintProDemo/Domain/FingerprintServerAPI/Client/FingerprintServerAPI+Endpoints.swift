import FingerprintPro
import Foundation

extension FingerprintServerAPI {

    enum Endpoint: URLConvertibleEndpoint {

        case demoEvent(requestId: String)
        case subscriptionEvent(apiKey: String, region: Region, requestId: String)

        var baseURL: URL {
            get throws {
                switch self {
                case .demoEvent:
                    guard let url = ConfigVariable.SmartSignals.baseURL else {
                        throw NetworkingError.invalidURL(url: self)
                    }
                    return url
                case let .subscriptionEvent(_, region, _):
                    return try region.description.asURL()
                }
            }
        }

        var path: String {
            switch self {
            case let .demoEvent(requestId): "/event/\(requestId)"
            case let .subscriptionEvent(_, _, requestId): "/events/\(requestId)"
            }
        }

        var method: HTTPMethod {
            switch self {
            case .demoEvent, .subscriptionEvent: .get
            }
        }

        var headerFields: Set<HTTPHeaderField> {
            var fields: Set<HTTPHeaderField> = [
                .accept("application/json")
            ]
            if let origin = ConfigVariable.SmartSignals.origin.map(HTTPHeaderField.origin) {
                fields.insert(origin)
            }
            if case let .subscriptionEvent(apiKey, _, _) = self {
                fields.insert(.custom(name: "Auth-API-Key", value: apiKey))
            }

            return fields
        }
    }
}
