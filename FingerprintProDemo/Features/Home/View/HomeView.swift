import SwiftUI

struct HomeView: View {

    private enum VisualState: Equatable {
        case tapToBegin
        case deviceFingerprint
    }

    @State private var state: VisualState = .tapToBegin

    var body: some View {
        // Used NavigationView instead of newer NavigationStack, as the latter one causes
        // the animated button to run crazy (potential SwiftUI bug).
        NavigationView {
            VStack(spacing: 32.0) {
                switch state {
                case .tapToBegin:
                    Spacer()
                    Text("Tap to begin")
                        .font(.inter(size: 20.0, weight: .semibold))
                    Button(
                        action: {
                            state = .deviceFingerprint
                        },
                        label: {
                            Image("Button/FingerprintImage")
                        }
                    )
                    .buttonStyle(.fingerprint)
                    .padding(.bottom, 96.0)
                case .deviceFingerprint:
                    MockDeviceFingerprintView(
                        presentation: .extendedResponse,
                        mockPresentationData: extendedResponseMockData
                    )
                }
            }
            .animation(.easeInOut(duration: 0.25).delay(0.15), value: state)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Link(destination: C.URLs.documentation) {
                            Label("Documentation", systemImage: "book")
                        }
                        Link(destination: C.URLs.support) {
                            Label("Support", systemImage: "message")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
        }
        .tint(.accent)
        .navigationViewStyle(.stack)
    }
}

private extension HomeView {

    struct MockDeviceFingerprintView<Presentation: EventPresentability>: View {

        typealias MockPresentationData = (fieldValue: (Presentation.FieldKey) -> String, rawDetails: String)

        private let presentation: Presentation
        private let mockPresentationData: MockPresentationData

        @State private var state: EventDetailsView<Presentation>.VisualState = .loading

        init(presentation: Presentation, mockPresentationData: MockPresentationData) {
            self.presentation = presentation
            self.mockPresentationData = mockPresentationData
        }

        var body: some View {
            ScrollView {
                EventDetailsView(presentation: presentation, state: $state)
                    .padding(.horizontal, 16.0)
            }
            .task {
                try? await Task.sleep(for: .seconds(3))
                state = .presenting(
                    fieldValue: mockPresentationData.fieldValue,
                    rawDetails: mockPresentationData.rawDetails
                )
            }
            .refreshable {
                state = .loading
                try? await Task.sleep(for: .seconds(2))
                state = .presenting(
                    fieldValue: mockPresentationData.fieldValue,
                    rawDetails: mockPresentationData.rawDetails
                )
            }
        }
    }
}

private extension HomeView {

    typealias ExtendedResponseMockData = HomeView
        .MockDeviceFingerprintView<ExtendedResponseEventPresentability>
        .MockPresentationData

    var extendedResponseMockData: ExtendedResponseMockData {
        (
            fieldValue: { key in
                switch key {
                case .requestId:
                    return "1702058653176.gO9SYo"
                case .visitorId:
                    return "rVC74CiaXVZGVC69OBsP"
                case .visitorFound:
                    return String(localized: "Yes")
                case .confidence:
                    return "100%"
                case .ipAddress:
                    return "79.184.247.29"
                case .ipLocation:
                    return "Warsaw, Poland"
                case .firstSeenAt:
                    return "2023-10-31T12:38:31.79Z"
                case .lastSeenAt:
                    return "2023-12-08T18:04:13.201Z"
                }
            },
            rawDetails: """
                          {
                            "v" : "2",
                            "requestId" : "1702058653176.gO9SYo",
                            "visitorId" : "rVC74CiaXVZGVC69OBsP",
                            "visitorFound" : true,
                            "confidence" : 1,
                            "ip" : "79.184.247.29",
                            "ipLocation" : {
                              "city" : {
                                "name" : "Warsaw"
                              },
                              "country" : {
                                "name" : "Poland",
                                "code" : "PL"
                              },
                              "longitude" : 21.006,
                              "postalCode" : "00-021",
                              "continent" : {
                                "name" : "Europe",
                                "code" : "EU"
                              },
                              "subdivisions" : [
                                {
                                  "isoCode" : "14",
                                  "name" : "Mazovia"
                                }
                              ],
                              "latitude" : 52.234000000000002,
                              "timezone" : "Europe/Warsaw",
                              "accuracyRadius" : 20
                            },
                            "firstSeenAt" : {
                              "global" : "2023-10-31T12:38:31.79Z",
                              "subscription" : "2023-10-31T12:38:31.79Z"
                            },
                            "lastSeenAt" : {
                              "global" : "2023-12-08T18:04:13.201Z",
                              "subscription" : "2023-12-08T18:04:13.201Z"
                            }
                          }
                          """
        )
    }
}

#Preview {
    HomeView()
}
