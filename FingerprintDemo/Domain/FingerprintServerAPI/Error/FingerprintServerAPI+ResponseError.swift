import Foundation

extension FingerprintServerAPI {

    struct ResponseError: Error, Decodable {

        enum ErrorCode: String, Decodable {
            case failed = "Failed"
            case featureNotEnabled = "FeatureNotEnabled"
            case requestCannotBeParsed = "RequestCannotBeParsed"
            case requestNotFound = "RequestNotFound"
            case subscriptionNotActive = "SubscriptionNotActive"
            case tokenNotFound = "TokenNotFound"
            case tokenRequired = "TokenRequired"
            case tooManyRequests = "TooManyRequests"
            case wrongRegion = "WrongRegion"
        }

        let code: ErrorCode
        let message: String

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let nestedContainer = try container.nestedContainer(
                keyedBy: NestedCodingKeys.self,
                forKey: .error
            )
            self.code = try nestedContainer.decode(ErrorCode.self, forKey: .code)
            self.message = try nestedContainer.decode(String.self, forKey: .message)
        }
    }
}

extension FingerprintServerAPI.ResponseError {

    init?(from error: NetworkingError) {
        guard case let .responseError(_, errorData) = error else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let responseError = try? decoder.decode(Self.self, from: errorData) else {
            return nil
        }

        self = responseError
    }
}

private extension FingerprintServerAPI.ResponseError {

    enum CodingKeys: String, CodingKey {
        case error
    }

    enum NestedCodingKeys: String, CodingKey {
        case code
        case message
    }
}
