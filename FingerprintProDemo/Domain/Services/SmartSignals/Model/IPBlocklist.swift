import Foundation

struct IPBlocklist: Codable, Equatable, Sendable {
    let emailSpam: Bool?
    let attackSource: Bool?
    let torNode: Bool?
}
