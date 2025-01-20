import Foundation

enum NetworkingError: Error {
    case createURLRequestFailed(error: any Error)
    case invalidResponse
    case invalidURL(url: any URLConvertible)
    case payloadEncodingFailed(error: any Error)
    case responseDecodingFailed(error: any Error)
    case responseError(errorCode: Int, errorData: Data)
    case requestFailed(error: any Error)
}

extension NetworkingError {

    var isCreateURLRequestFailedError: Bool {
        if case .createURLRequestFailed = self { true } else { false }
    }

    var isInvalidResponseError: Bool {
        if case .invalidResponse = self { true } else { false }
    }

    var isInvalidURLError: Bool {
        if case .invalidURL = self { true } else { false }
    }

    var isPayloadEncodingFailedError: Bool {
        if case .payloadEncodingFailed = self { true } else { false }
    }

    var isResponseDecodingFailedError: Bool {
        if case .responseDecodingFailed = self { true } else { false }
    }

    var isResponseError: Bool {
        if case .responseError = self { true } else { false }
    }

    var isRequestFailedError: Bool {
        if case .requestFailed = self { true } else { false }
    }
}
