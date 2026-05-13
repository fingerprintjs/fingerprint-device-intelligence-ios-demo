import FingerprintPro
import Foundation

extension FingerprintServerAPI {

    enum Endpoint: URLConvertibleEndpoint {

        case proxyEvent(requestId: String, tag: String)

        var baseURL: URL {
            get throws {
                switch self {
                case .proxyEvent:
                    guard let url = ConfigVariable.SmartSignals.baseURL else {
                        throw NetworkingError.invalidURL(url: self)
                    }
                    return url
                }
            }
        }

        var path: String {
            switch self {
            case let .proxyEvent(requestId, _): "event/v4/\(requestId)"
            }
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case let .proxyEvent(_, tag): [.init(name: "secret", value: tag)]
            }
        }

        var method: HTTPMethod {
            switch self {
            case .proxyEvent: .get
            }
        }

        var headerFields: Set<HTTPHeaderField> {
            var fields: Set<HTTPHeaderField> = [
                .accept("application/json")
            ]

            if let basicAuthToken = ConfigVariable.SmartSignals.basicAuthToken {
                fields.insert(.basicAuthorization(basicAuthToken))
            }

            if let basicAuthToken = ConfigVariable.SmartSignals.basicAuthToken {
                fields.insert(.basicAuthorization(basicAuthToken))
            }

            return fields
        }
    }
}
