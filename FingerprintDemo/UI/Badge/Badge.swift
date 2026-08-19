import Foundation

enum Badge: Equatable, Sendable {
    case plain(String)
    case link(String, destination: URL)
}
