import Foundation

protocol URLConvertible: Sendable {
    func asURL() throws -> URL
}

extension URL: URLConvertible {

    func asURL() -> URL { self }
}
