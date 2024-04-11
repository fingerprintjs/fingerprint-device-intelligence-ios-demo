import Foundation

extension SmartSignalsResponse {

    private enum PreviewData {
        static var dailyRequests: Int = .zero
        static var isHighActivity: Bool { dailyRequests >= 3 }
    }

    static var preview: Self {
        PreviewData.dailyRequests += 1
        let factoryResetTimestamp: Int64 = .init(Date.now.advanced(by: -3600).timeIntervalSince1970)
        return .init(
            products: .init(
                factoryReset: .init(
                    data: .init(
                        time: .init(timeIntervalSince1970: .init(factoryResetTimestamp)),
                        timestamp: factoryResetTimestamp
                    )
                ),
                frida: .init(
                    data: .init(result: false)
                ),
                highActivity: .init(
                    data: .init(
                        result: PreviewData.isHighActivity,
                        dailyRequests: PreviewData.dailyRequests
                    )
                ),
                jailbroken: .init(
                    data: .init(result: false)
                ),
                locationSpoofing: .init(
                    data: .init(result: false)
                ),
                vpn: .init(
                    data: .init(
                        result: true,
                        originTimezone: "America/Anchorage",
                        originCountry: "US",
                        methods: .init(
                            timezoneMismatch: false,
                            publicVPN: false,
                            auxiliaryMobile: false
                        )
                    )
                )
            )
        )
    }
}
