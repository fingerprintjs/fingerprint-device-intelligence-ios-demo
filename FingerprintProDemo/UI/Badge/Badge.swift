import Foundation

enum Badge: Equatable {
    case plain(String)
    case link(String, destination: URL)
}
