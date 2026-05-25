import Foundation

struct IPInfo: Codable, Equatable, Sendable {
    let v4: IPDetails?

    enum CodingKeys: String, CodingKey {
        case v4
    }

    struct IPDetails: Codable, Equatable, Sendable {
        let address: String?
        let geolocation: Geolocation?
        let asn: String?
        let asnName: String?
        let asnNetwork: String?
        let asnType: String?
        let datacenterResult: Bool?

        struct Geolocation: Codable, Equatable, Sendable {
            let accuracyRadius: Int?
            let latitude: Double?
            let longitude: Double?
            let postalCode: String?
            let timezone: String?
            let cityName: String?
            let countryCode: String?
            let countryName: String?
            let continentCode: String?
            let continentName: String?
            let subdivisions: [Subdivision]?
        }

        struct Subdivision: Codable, Equatable, Sendable {
            let isoCode: String?
            let name: String?
        }
    }
}
