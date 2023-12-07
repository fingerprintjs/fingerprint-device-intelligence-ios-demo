import SwiftUI

struct EventDetailsView<Presentation: EventPresentability>: View {

    private let presentation: Presentation

    @Binding private var state: VisualState

    @State private var detailsDisplayMode: DetailsDisplayMode = .prettified

    init(presentation: Presentation, state: Binding<VisualState>) {
        self.presentation = presentation
        self._state = state
    }

    var body: some View {
        VStack(spacing: .zero) {
            if showHeading {
                heading
                Spacer()
                    .frame(height: 32.0)
            }
            foremostField
            Spacer()
                .frame(height: isLoading ? 16.0 : 24.0)
            details
            Spacer(minLength: 32.0)
        }
        .redacted(if: isLoading)
        .animation(.easeInOut(duration: 0.35), value: state)
    }
}

private extension EventDetailsView {

    @ViewBuilder
    var heading: some View {
        VStack(spacing: 8.0) {
            Group {
                if let headingTitleKey {
                    Text(headingTitleKey)
                        .font(.inter(size: 24.0, relativeTo: .title, weight: .semibold))
                        .foregroundStyle(.extraDarkGray)
                        .lineLimit(1)
                }

                if isLoading, let headingDescriptionKey {
                    Text(headingDescriptionKey)
                        .font(.inter(size: 16.0))
                        .foregroundStyle(.mediumGray)
                        .lineLimit(3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .unredacted()
        }
    }

    @ViewBuilder
    var foremostField: some View {
        VStack(spacing: 4.0) {
            Group {
                Text(foremostFieldKey)
                    .font(.inter(size: 12.0))
                    .kerning(0.36)
                    .foregroundStyle(.regularGray)
                    .unredacted()

                Text(foremostFieldValue)
                    .font(.inter(size: 22.0, weight: .medium))
                    .foregroundStyle(isPresenting ? .accent : .extraDarkGray)
                    .textSelection(.enabled)
                    .disabled(isLoading)
                    .transaction { transaction in
                        guard presentation.loadingDescriptionKey != .none else { return }
                        if isLoading {
                            transaction.animation = .easeOut(duration: 0.15)
                        } else {
                            transaction.animation = .easeInOut(duration: 0.15).delay(0.2)
                        }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    var details: some View {
        VStack(spacing: 8.0) {
            Text(detailsHeaderKey)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.inter(size: 12.0))
                .kerning(0.36)
                .foregroundStyle(.regularGray)
                .unredacted()

            Picker(selection: $detailsDisplayMode.animation()) {
                ForEach(DetailsDisplayMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                        .unredacted()
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.segmented)
            .disabled(isLoading)

            switch detailsDisplayMode {
            case .prettified:
                prettifiedDetails
            case .raw:
                rawDetails
            }
        }
        .onChange(of: state) { _ in
            detailsDisplayMode = .prettified
        }
    }

    @ViewBuilder
    var prettifiedDetails: some View {
        VStack(spacing: 16.0) {
            switch state {
            case .loading:
                ForEach(Presentation.fieldMetadata, id: \.id) { metadata in
                    DetailsFieldView(
                        key: metadata.key.rawValue,
                        value: presentation.valuePlaceholder(for: metadata.key)
                    )
                }
            case let .presenting(fieldValue, _):
                ForEach(Presentation.fieldMetadata, id: \.id) { metadata in
                    DetailsFieldView(
                        key: metadata.key.rawValue,
                        value: fieldValue(metadata.key)
                    )
                }
            }
        }
        .padding(.all, 16.0)
        .background(.backgroundGray)
        .clipShape(RoundedRectangle(cornerRadius: 4.0))
    }

    @ViewBuilder
    var rawDetails: some View {
        HStack(spacing: 24.0) {
            switch state {
            case .loading:
                Spacer()
                    .frame(height: 200.0)
            case let .presenting(_, rawDetails):
                Group {
                    Text(lineNumbersString(for: rawDetails))
                        .multilineTextAlignment(.trailing)
                    ScrollView(.horizontal) {
                        Text(rawDetails)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                            .disabled(isLoading)
                    }
                }
                .font(.system(size: 12.0, weight: .light, design: .monospaced))
                .foregroundStyle(.semiDarkGray)
            }
        }
        .padding(.horizontal, 8.0)
        .padding(.vertical, 16.0)
        .background(.backgroundGray)
        .clipShape(RoundedRectangle(cornerRadius: 4.0))
    }
}

private extension EventDetailsView {

    var isLoading: Bool { state == .loading }

    var isPresenting: Bool {
        switch state {
        case .presenting:
            return true
        default:
            return false
        }
    }

    var showHeading: Bool {
        switch state {
        case .loading:
            return presentation.loadingTitleKey != .none || presentation.loadingDescriptionKey != .none
        case .presenting:
            return presentation.presentingTitleKey != .none
        }
    }

    var headingTitleKey: LocalizedStringKey? {
        switch state {
        case .loading:
            return presentation.loadingTitleKey
        case .presenting:
            return presentation.presentingTitleKey
        }
    }

    var headingDescriptionKey: LocalizedStringKey? {
        switch state {
        case .loading:
            return presentation.loadingDescriptionKey
        case .presenting:
            return .none
        }
    }

    var foremostFieldKey: LocalizedStringKey { presentation.foremostFieldKey.rawValue }

    var foremostFieldValue: String {
        let key = presentation.foremostFieldKey
        switch state {
        case .loading:
            return presentation.valuePlaceholder(for: key)
        case let .presenting(fieldValue, _):
            return fieldValue(key)
        }
    }

    var detailsHeaderKey: LocalizedStringKey { presentation.detailsHeaderKey }

    func lineNumbersString(for text: String) -> String {
        (1...text.linesCount)
            .map { "\($0)" }
            .joined(separator: "\n")
    }
}

private extension EventDetailsView {

    enum DetailsDisplayMode: LocalizedStringKey, CaseIterable {
        case prettified = "PRETTIFIED"
        case raw = "RAW"
    }

    struct DetailsFieldView: View {

        private let key: LocalizedStringKey
        private let value: String

        init(key: LocalizedStringKey, value: String) {
            self.key = key
            self.value = value
        }

        var body: some View {
            VStack(spacing: 4.0) {
                Group {
                    Text(key)
                        .font(.inter(size: 9.0))
                        .kerning(0.36)
                        .foregroundStyle(.regularGray)
                        .unredacted()
                    Text(value)
                        .font(.inter(size: 14.0))
                        .kerning(0.14)
                        .foregroundStyle(.extraDarkGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private extension EventPresentability {

    static var fieldMetadata: [(id: UUID, key: FieldKey)] {
        FieldKey.allCases.map { (.init(), $0) }
    }
}

#Preview("Loading") {
    EventDetailsView(
        presentation: .basicResponse,
        state: .constant(.loading)
    )
    .padding(.top, 38.0)
    .padding(.horizontal, 16.0)
}

#Preview("Presenting") {
    EventDetailsView(
        presentation: .basicResponse,
        state: .constant(
            .presenting(
                fieldValue: { key in
                    switch key {
                    case .requestId:
                        return "1702058653176.gO9SYo"
                    case .visitorId:
                        return "rVC74CiaXVZGVC69OBsP"
                    case .visitorFound:
                        return "Yes"
                    case .confidence:
                        return "100%"
                    }
                },
                rawDetails: """
                              {
                                "v" : "2",
                                "requestId" : "1702058653176.gO9SYo",
                                "visitorId" : "rVC74CiaXVZGVC69OBsP",
                                "visitorFound" : true,
                                "confidence" : 1
                              }
                              """
            )
        )
    )
    .padding(.top, 38.0)
    .padding(.horizontal, 16.0)
}
