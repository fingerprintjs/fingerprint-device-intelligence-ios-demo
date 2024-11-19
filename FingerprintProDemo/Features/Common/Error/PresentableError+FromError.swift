import FingerprintPro

extension PresentableError {

    init(from error: Error) {
        switch error {
        case FPJSError.networkError:
            self = .networkError
        case let FPJSError.apiError(underlyingError) where underlyingError.isTokenExpiredError:
            self = .publicApiKeyExpiredError
        case let FPJSError.apiError(underlyingError) where underlyingError.isTokenNotFoundError:
            self = .publicApiKeyInvalidError
        case let FPJSError.apiError(underlyingError) where underlyingError.isSubscriptionNotActiveError:
            self = .subscriptionNotActiveError
        case let FPJSError.apiError(underlyingError) where underlyingError.isTooManyRequestsError:
            self = .tooManyRequestsError
        case let FPJSError.apiError(underlyingError) where underlyingError.isWrongRegionError:
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

    var isTokenExpiredError: Bool { error?.code == .tokenExpired }
    var isTokenNotFoundError: Bool { error?.code == .tokenNotFound }
    var isSubscriptionNotActiveError: Bool { error?.code == .subscriptionNotActive }
    var isTooManyRequestsError: Bool { error?.code == .tooManyRequests }
    var isWrongRegionError: Bool { error?.code == .wrongRegion }
}

private extension FingerprintServerAPI.ResponseError {

    var isTokenNotFoundError: Bool { code == .tokenNotFound }
    var isTokenMismatchError: Bool {
        code == .requestNotFound || code == .subscriptionNotActive || code == .wrongRegion
    }
}
