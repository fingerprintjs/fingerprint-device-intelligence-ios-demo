import Foundation

struct SmartSignalsResponse: Codable, Equatable, Sendable {
    let eventId: String?
    let timestamp: Int64?
    let environmentId: String?
    let sdk: SDK?
    let replayed: Bool?
    let identification: Identification?
    let bundleId: String?
    let ipAddress: String?
    let userAgent: String?
    let proximity: Proximity?
    let factoryResetTimestamp: Int64?
    let frida: Bool?
    let ipBlocklist: IPBlocklist?
    let ipInfo: IPInfo?
    let proxy: Bool?
    let proxyConfidence: String?
    let proxyDetails: ProxyDetails?
    let jailbroken: Bool?
    let locationSpoofing: Bool?
    let mitmAttack: Bool?
    let suspectScore: Int?
    let tampering: Bool?
    let tamperingConfidence: String?
    let tamperingMlScore: Double?
    let tamperingDetails: TamperingDetails?
    let velocity: Velocity?
    let vpn: Bool?
    let vpnConfidence: String?
    let vpnOriginTimezone: String?
    let vpnOriginCountry: String?
    let vpnMethods: VPNMethods?
    let highActivityDevice: Bool?
    let simulator: Bool?
}
