import Foundation

extension URL {

    func withFragment<S: StringProtocol>(_ fragment: S) -> Self {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.fragment = .init(fragment)
        guard let url = components?.url else {
            preconditionFailure("Unexpected URL creation failure")
        }

        return url
    }
}
