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
                            originTimezone: "America/Anchorage",
                            originCountry: "US",
                            methods: .init(
                                timezoneMismatch: false,
                                publicVPN: false,
                                auxiliaryMobile: false,
                                relay: false
                            )
                        )
                    )
                )
            )
        }
    }
}
