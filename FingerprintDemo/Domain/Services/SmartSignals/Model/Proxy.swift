import Foundation

struct ProxyDetails: Codable, Equatable, Sendable {
    let proxyType: ProxyType?
    let lastSeenAt: Int64?
    let provider: String?

    enum ProxyType: String, Codable, Equatable, Sendable {
        case residential
        case dataCenter = "data_center"
    }
}
