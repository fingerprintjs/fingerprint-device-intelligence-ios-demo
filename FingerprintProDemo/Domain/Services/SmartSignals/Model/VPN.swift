import Foundation

struct VPNMethods: Codable, Equatable, Sendable {
    let timezoneMismatch: Bool?
    let publicVPN: Bool?
    let auxiliaryMobile: Bool?
    let relay: Bool?
}
