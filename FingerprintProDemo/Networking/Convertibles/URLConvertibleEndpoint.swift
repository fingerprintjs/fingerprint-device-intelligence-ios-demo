import Foundation

protocol URLConvertibleEndpoint: URLConvertible {
    var baseURL: URL { get throws }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension URLConvertibleEndpoint {

    var queryItems: [URLQueryItem] { [] }

    func asURL() throws -> URL {
        let url = path.isEmpty ? try baseURL : try baseURL.appendingPathComponent(path)
        guard !queryItems.isEmpty else { return url }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        components.queryItems = queryItems
        guard let urlWithQuery = components.url else { return url }
        return urlWithQuery
    }
}

extension URLConvertibleEndpoint where Self: RawRepresentable, RawValue == String {

    var path: String { rawValue }
}
