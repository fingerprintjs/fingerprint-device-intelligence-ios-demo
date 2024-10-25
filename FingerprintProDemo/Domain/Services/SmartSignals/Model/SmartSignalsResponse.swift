import Foundation

struct SmartSignalsResponse: Decodable, Equatable, Sendable {

    let products: Products

    struct Products: Codable, Equatable, Sendable {
        let factoryReset: FactoryResetSignal
        let frida: FridaSignal
        let highActivity: HighActivitySignal
        let jailbroken: JailbreakSignal
        let locationSpoofing: LocationSpoofingSignal
        let vpn: VPNSignal
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

    var factoryResetDate: Date { products.factoryReset.data.time }
    var factoryResetDetected: Bool { products.factoryReset.data.timestamp > 0 }
}

extension SmartSignalsResponse {

    typealias FridaSignal = Result<Bool>

    var fridaDetected: Bool { products.frida.data.result }
}

extension SmartSignalsResponse {

    struct HighActivitySignal: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {
            let result: Bool
            let dailyRequests: Int?
        }

        let data: Data
    }

    var deviceDailyRequests: Int? { products.highActivity.data.dailyRequests }
    var isHighActivityDevice: Bool { products.highActivity.data.result }
}

extension SmartSignalsResponse {

    typealias JailbreakSignal = Result<Bool>

    var jailbreakDetected: Bool { products.jailbroken.data.result }
}

extension SmartSignalsResponse {

    typealias LocationSpoofingSignal = Result<Bool>

    var locationSpoofingDetected: Bool { products.locationSpoofing.data.result }
}

extension SmartSignalsResponse {

    struct VPNSignal: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {

            struct Methods: Codable, Equatable, Sendable {
                let timezoneMismatch: Bool
                let publicVPN: Bool
                let auxiliaryMobile: Bool
            }

            let result: Bool
            let originTimezone: String
            let originCountry: String
            let methods: Methods
        }

        let data: Data
    }

    var deviceTimezone: String { products.vpn.data.originTimezone }
    var vpnDetected: Bool { products.vpn.data.result }
}

extension SmartSignalsResponse {

    struct Result<T: Codable & Equatable & Sendable>: Codable, Equatable, Sendable {

        struct Data: Codable, Equatable, Sendable {
            let result: T
        }

        let data: Data
    }
}
