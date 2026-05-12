import FingerprintPro
import Foundation

extension FingerprintServerAPI {

    enum Endpoint: URLConvertibleEndpoint {

        case demoEvent(requestId: String)

        var baseURL: URL {
            get throws {
                switch self {
                case .demoEvent:
                    guard let url = ConfigVariable.SmartSignals.baseURL else {
                        throw NetworkingError.invalidURL(url: self)
                    }
                    return url
                }
            }
        }

        var path: String {
            switch self {
            case let .demoEvent(requestId): "/event/\(requestId)"
            }
        }

        var method: HTTPMethod {
            switch self {
            case .demoEvent: .get
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
}
