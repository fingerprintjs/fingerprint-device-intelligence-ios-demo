import Foundation

struct Velocity: Codable, Equatable, Sendable {
    let distinctIp: VelocityWindows?
    let distinctCountry: VelocityWindows?
    let events: VelocityWindows?
    let ipEvents: VelocityWindows?

    struct VelocityWindows: Codable, Equatable, Sendable {
        let fiveMinutes: Int?
        let oneHour: Int?
        let twentyFourHours: Int?

        enum CodingKeys: String, CodingKey {
            case fiveMinutes = "5Minutes"
            case oneHour = "1Hour"
            case twentyFourHours = "24Hours"
        }
    }
}
