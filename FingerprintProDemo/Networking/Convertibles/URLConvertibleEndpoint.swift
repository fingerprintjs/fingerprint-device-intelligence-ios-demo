import Foundation

protocol URLConvertibleEndpoint: URLConvertible {
    var baseURL: URL { get throws }
    var path: String { get }
}

extension URLConvertibleEndpoint {

    func asURL() throws -> URL {
        path.isEmpty ? try baseURL : try baseURL.appendingPathComponent(path)
    }
}

extension URLConvertibleEndpoint where Self: RawRepresentable, RawValue == String {

    var path: String { rawValue }
}
