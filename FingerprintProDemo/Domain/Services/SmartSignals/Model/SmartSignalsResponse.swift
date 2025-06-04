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
    }
}
