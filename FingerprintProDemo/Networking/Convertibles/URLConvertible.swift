import Foundation

protocol URLConvertible {
    func asURL() throws -> URL
}

extension URL: URLConvertible {

    func asURL() throws -> URL { self }
}
