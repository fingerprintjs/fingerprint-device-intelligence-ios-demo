import Foundation

struct Identification: Codable, Equatable, Sendable {
    let visitorId: String?
    let confidence: Confidence?
    let visitorFound: Bool?
    let firstSeenAt: Int64?
    let lastSeenAt: Int64?

    struct Confidence: Codable, Equatable, Sendable {
        let score: Double?
        let version: String?
    }
}
