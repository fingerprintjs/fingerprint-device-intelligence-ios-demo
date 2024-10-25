import Foundation

protocol URLRequestConvertible: Sendable {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: URLRequestConvertible {

    func asURLRequest() -> URLRequest { self }
}
