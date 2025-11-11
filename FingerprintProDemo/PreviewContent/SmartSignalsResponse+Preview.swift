import Foundation
import os

extension SmartSignalsResponse {

    private struct PreviewData: Sendable {
        var dailyRequests: Int = .zero
        var isHighActivity: Bool { dailyRequests >= 3 }
    }

    private static let previewData = OSAllocatedUnfairLock<PreviewData>(initialState: .init())

    static var preview: Self {
        previewData.withLock { previewData in
            previewData.dailyRequests += 1
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
                            result: previewData.isHighActivity,
                            dailyRequests: previewData.dailyRequests
                        )
                    ),
                    jailbreak: .init(
                        data: .init(result: false)
                    ),
                    locationSpoofing: .none,
                    vpn: .init(
                        data: .init(
                            result: true,
                            confidence: "high",
                            originTimezone: "America/Anchorage",
                            originCountry: "US",
                            methods: .init(
                                timezoneMismatch: false,
                                publicVPN: false,
                                auxiliaryMobile: false,
                                relay: false
                            )
                        )
                    ),
                    tampering: .init(
                        data: .init(result: false)
                    ),
                    mitmAttack: .init(
                        data: .init(result: false)
                    ),
                    ipInfo: .init(
                        data: .init(
                            v4: .init(
                                asn: .init(asn: "7922", name: "COMCAST-7922", network: "73.136.0.0/13"),
                                datacenter: .init(name: "DediPath", result: true),
                                geolocation: .init(
                                    accuracyRadius: 20, latitude: 50.05, longitude: 14.4, postalCode: "150 00",
                                    timezone: "Europe/Prague", city: .init(name: "Prague"),
                                    country: .init(code: "CZ", name: "Czechia"),
                                    continent: .init(code: "EU", name: "Europe"))))
                    ),
                    ipBlocklist: .init(
                        data: .init(
                            result: false,
                            details: .init(
                                emailSpam: false, attackSource: false))),
                    proxy: .init(
                        data: .init(
                            result: false, confidence: "high",
                            details: .init(
                                proxyType: .dataCenter, lastSeenAs: nil)))
                )
            )
        }
    }
}
