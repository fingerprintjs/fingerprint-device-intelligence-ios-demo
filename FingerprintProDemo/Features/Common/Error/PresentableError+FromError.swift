import FingerprintPro

extension PresentableError {

    init(from error: Error) {
        switch error {
        case FPJSError.networkError:
            self = .networkError
        case let FPJSError.apiError(underlyingError) where underlyingError.error?.code == .tooManyRequests:
            self = .tooManyRequestsError
        default:
            self = .unknownError
        }
    }
}
