import FingerprintPro
import Foundation

extension FingerprintResponse {

    static var preview: Self {
        let lastSeenAt: Date = .now
        return .init(
            version: "2",
            requestId: "1808306341094.vuw6U9",
            visitorId: "xZ327iYJLcH6VZfo7Eu2",
            visitorFound: true,
            confidence: 1.0,
            ipAddress: "72.42.140.250",
            ipLocation: .init(
                city: .init(name: "North Pole", code: .none),
                country: .init(name: "United States", code: "US"),
                continent: .init(name: "North America", code: "NA"),
                longitude: -147.3494,
                latitude: 64.7511,
                postalCode: "99705",
                timezone: "America/Anchorage",
                accuracyRadius: 20,
                subdivisions: []
            ),
            firstSeenAt: .init(
                global: Date(timeIntervalSince1970: 1_700_673_178),
                subscription: Date(timeIntervalSince1970: 1_700_673_178)
            ),
            lastSeenAt: .init(
                global: lastSeenAt,
                subscription: lastSeenAt
            )
        )
    }
}
