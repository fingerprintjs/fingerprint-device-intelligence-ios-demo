import Fingerprint

extension PresentableError {

    init(from error: any Error) {
        switch error {
        case FPError.networkError:
            self = .networkError
        case let FPError.apiError(underlyingError) where underlyingError.isPublicApiKeyInvalidError:
            self = .publicApiKeyInvalidError
        case let FPError.apiError(underlyingError) where underlyingError.isSubscriptionNotActiveError:
            self = .subscriptionNotActiveError
        case let FPError.apiError(underlyingError) where underlyingError.isTooManyRequestsError:
            self = .tooManyRequestsError
        case let FPError.apiError(underlyingError) where underlyingError.isWrongRegionError:
            self = .wrongRegionError
        case let error as FingerprintServerAPI.ResponseError where error.isTokenMismatchError:
            self = .secretApiKeyMismatchError
        case let error as FingerprintServerAPI.ResponseError where error.isTokenNotFoundError:
            self = .secretApiKeyInvalidError
        default:
            self = .unknownError
        }
    }
}

private extension APIError {

    var isPublicApiKeyInvalidError: Bool {
        errorDetails?.code == .publicApiKeyNotFound || errorDetails?.code == .publicApiKeyRequired
    }
    var isSubscriptionNotActiveError: Bool { errorDetails?.code == .subscriptionNotActive }
    var isTooManyRequestsError: Bool { errorDetails?.code == .tooManyRequests }
    var isWrongRegionError: Bool { errorDetails?.code == .wrongRegion }
}

private extension FingerprintServerAPI.ResponseError {

    var isTokenNotFoundError: Bool { code == .tokenNotFound }
    var isTokenMismatchError: Bool {
        code == .requestNotFound || code == .subscriptionNotActive || code == .wrongRegion
    }
}
