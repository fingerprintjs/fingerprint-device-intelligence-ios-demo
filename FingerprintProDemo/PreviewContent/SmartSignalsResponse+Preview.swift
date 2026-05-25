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
                eventId: "event-id",
                timestamp: .init(Date().timeIntervalSince1970),
                environmentId: "environment-id",
                sdk: .init(
                    platform: "ios",
                    version: "2.14.0"),
                replayed: false,
                identification: .init(
                    visitorId: "visitor-id",
                    confidence: .init(score: 1, version: "v1.1"),
                    visitorFound: true,
                    firstSeenAt: 1_761_293_949_605,
                    lastSeenAt: 1_761_293_949_605),
                bundleId: Bundle.main.bundleIdentifier,
                ipAddress: "217.66.188.129",
                userAgent: "FingerprintProDemo/1 CFNetwork/3860.100.1 Darwin/25.3.0",
                proximity: .init(id: "jpkktgV8jD1", precisionRadius: 10, confidence: 0.66),
                factoryResetTimestamp: factoryResetTimestamp,
                frida: false,
                ipBlocklist: .init(emailSpam: false, attackSource: false, torNode: false),
                ipInfo: .init(
                    v4: .init(
                        address: "217.66.188.129",
                        geolocation: .init(
                            accuracyRadius: 5000, latitude: 49.19522, longitude: 16.60796, postalCode: "602 00",
                            timezone: "Europe/Prague", cityName: "Brno", countryCode: "CZ", countryName: "Czechia",
                            continentCode: "EU", continentName: "Europe",
                            subdivisions: [.init(isoCode: "64", name: "South Moravian")]), asn: "15935",
                        asnName: "ha-vel internet s.r.o.", asnNetwork: "217.66.160.0/19", asnType: "isp",
                        datacenterResult: false)), proxy: true, proxyConfidence: "low",
                proxyDetails: .init(proxyType: .residential, lastSeenAt: 1_773_014_400_000, provider: "PrivateProxy"),
                jailbroken: false, locationSpoofing: true, mitmAttack: false, suspectScore: 6, tampering: false,
                tamperingConfidence: "high", tamperingMlScore: 0, tamperingDetails: .init(anomalyScore: 0),
                velocity: .init(
                    distinctIp: .init(fiveMinutes: 1, oneHour: 1, twentyFourHours: 1),
                    distinctCountry: .init(fiveMinutes: 1, oneHour: 1, twentyFourHours: 1),
                    events: .init(fiveMinutes: 1, oneHour: 1, twentyFourHours: 5),
                    ipEvents: .init(fiveMinutes: 1, oneHour: 4, twentyFourHours: 30)), vpn: false,
                vpnConfidence: "medium", vpnOriginTimezone: "Europe/Prague", vpnOriginCountry: "CZ",
                vpnMethods: .init(timezoneMismatch: false, publicVPN: false, auxiliaryMobile: false, relay: false),
                highActivityDevice: false)
        }
    }
}
