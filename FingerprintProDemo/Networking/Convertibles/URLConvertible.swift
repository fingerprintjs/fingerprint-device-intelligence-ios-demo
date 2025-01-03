import Foundation

protocol URLConvertible: Sendable {
    func asURL() throws -> URL
}

extension String: URLConvertible {

    public func asURL() throws -> URL {
        let url: URL?
        if #available(iOS 17.0, *) {
            url = URL(string: self, encodingInvalidCharacters: false)
        } else {
            url = URL(string: self)
        }

        guard let url else {
            throw NetworkingError.invalidURL(url: self)
        }

        return url
    }
}

extension URL: URLConvertible {

    func asURL() -> URL { self }
}
