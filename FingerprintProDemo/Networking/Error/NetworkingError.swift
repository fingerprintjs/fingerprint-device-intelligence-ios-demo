import Foundation

enum NetworkingError: Error {
    case createURLRequestFailed(error: any Error)
    case invalidResponse
    case invalidURL(url: URLConvertible)
    case payloadEncodingFailed(error: any Error)
    case responseDecodingFailed(error: any Error)
    case responseError(errorCode: Int, errorData: Data)
    case requestFailed(error: any Error)
}

extension NetworkingError {

    var isCreateURLRequestFailedError: Bool {
        if case .createURLRequestFailed = self { return true }
        return false
    }

    var isInvalidResponseError: Bool {
        if case .invalidResponse = self { return true }
        return false
    }

    var isInvalidURLError: Bool {
        if case .invalidURL = self { return true }
        return false
    }

    var isPayloadEncodingFailedError: Bool {
        if case .payloadEncodingFailed = self { return true }
        return false
    }

    var isResponseDecodingFailedError: Bool {
        if case .responseDecodingFailed = self { return true }
        return false
    }

    var isResponseError: Bool {
        if case .responseError = self { return true }
        return false
    }

    var isRequestFailedError: Bool {
        if case .requestFailed = self { return true }
        return false
    }
}
