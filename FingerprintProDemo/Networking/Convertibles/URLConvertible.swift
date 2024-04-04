import Foundation

protocol URLConvertible {
    func asURL() throws -> URL
}

extension String: URLConvertible {

    func asURL() throws -> URL {
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

    func asURL() throws -> URL { self }
}
