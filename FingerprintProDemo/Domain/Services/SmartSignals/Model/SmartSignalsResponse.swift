import Foundation

struct SmartSignalsResponse: Decodable, Equatable, Sendable {

    let products: Products

    struct Products: Codable, Equatable, Sendable {
        let factoryReset: FactoryResetSignal?
        let frida: FridaSignal?
        let highActivity: HighActivitySignal?
        let jailbreak: JailbreakSignal?
        let locationSpoofing: LocationSpoofingSignal?
        let vpn: VPNSignal?
        let tampering: TamperingSignal?
        let mitmAttack: MitMAttackSignal?
        let ipInfo: IpInfo?
        let ipBlocklist: IpBlocklist?
        let proxy: Proxy?
    }
}

extension SmartSignalsResponse {

    struct FactoryResetSignal: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {
            let time: Date
            let timestamp: Int64
        }

        let data: Data
    }

    typealias FridaSignal = Result<Bool>

    struct HighActivitySignal: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {
            let result: Bool
            let dailyRequests: Int?
        }

        let data: Data
    }

    typealias JailbreakSignal = Result<Bool>

    typealias LocationSpoofingSignal = Result<Bool>

    struct VPNSignal: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {

            struct Methods: Codable, Equatable, Sendable {
                let timezoneMismatch: Bool
                let publicVPN: Bool
                let auxiliaryMobile: Bool
                let relay: Bool
            }

            let result: Bool
            let originTimezone: String
            let originCountry: String
            let methods: Methods
        }

        let data: Data
    }

    typealias TamperingSignal = Result<Bool>

    typealias MitMAttackSignal = Result<Bool>

    struct IpInfo: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {

            struct V4: Codable, Equatable, Sendable {

                struct Asn: Codable, Equatable, Sendable {
                    let asn: String
                    let name: String
                    let network: String
                }

                struct DataCenter: Codable, Equatable, Sendable {
                    let name: String
                    let result: Bool
                }

                struct Geolocation: Codable, Equatable, Sendable {

                    struct City: Codable, Equatable, Sendable {
                        let name: String
                    }

                    struct Country: Codable, Equatable, Sendable {
                        let code: String
                        let name: String
                    }

                    struct Continent: Codable, Equatable, Sendable {
                        let code: String
                        let name: String
                    }

                    let accuracyRadius: Int
                    let latitude: Double
                    let longitude: Double
                    let postalCode: String
                    let timezone: String
                    let city: City
                    let country: Country
                    let continent: Continent
                }

                let asn: Asn
                let datacenter: DataCenter
                let geolocation: Geolocation
            }

            let v4: V4
        }

        let data: Data
    }

    struct IpBlocklist: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {

            struct Details: Codable, Equatable, Sendable {

                let emailSpam: Bool
                let attackSource: Bool
            }

            let result: Bool
            let details: Details
        }

        let data: Data
    }

    struct Proxy: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {

            struct Details: Codable, Equatable, Sendable {

                enum ProxyType: String, Codable, Equatable, Sendable {

                    case residential, dataCenter

                    enum CodingKeys: String, CodingKey {
                        case dataCenter = "data_center"
                    }
                }

                let proxyType: ProxyType
                let lastSeenAs: Date?
            }

            let result: Bool
            let confidence: String
            let details: Details?
        }

        let data: Data
    }
}

extension SmartSignalsResponse {

    struct Result<T: Codable & Equatable & Sendable>: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {
            let result: T
        }

        let data: Data
    }
}

private extension SmartSignalsResponse.Products {

    enum CodingKeys: String, CodingKey {
        case factoryReset
        case frida
        case highActivity
        case jailbreak = "jailbroken"
        case locationSpoofing
        case vpn
        case tampering
        case mitmAttack
        case ipInfo
        case ipBlocklist
        case proxy
    }
}
