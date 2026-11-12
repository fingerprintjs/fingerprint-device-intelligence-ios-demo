import Foundation

struct DeviceDetails: Codable, Equatable, Sendable {
    let deviceManufacturer: String?
    let deviceModel: String?
    let osVersion: String?
}
