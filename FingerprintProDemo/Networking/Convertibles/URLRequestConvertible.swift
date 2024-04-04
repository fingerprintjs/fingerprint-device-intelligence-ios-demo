import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: URLRequestConvertible {

    func asURLRequest() throws -> URLRequest { self }
}
