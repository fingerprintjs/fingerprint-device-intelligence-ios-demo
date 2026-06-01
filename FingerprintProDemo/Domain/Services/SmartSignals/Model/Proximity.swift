import Foundation

struct Proximity: Codable, Equatable, Sendable {
    let id: String?
    let precisionRadius: Int?
    let confidence: Float?
}
