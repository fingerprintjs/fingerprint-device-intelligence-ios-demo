import SwiftUI

struct EventDetailsView<Presentation: EventPresentability, Actions: View>: View {

    private let presentation: Presentation
    private let actions: Actions

    @Binding private var state: VisualState

    @State private var detailsDisplayMode: DetailsDisplayMode = .prettified

    init(
        presentation: Presentation,
        state: Binding<VisualState>,
        @ViewBuilder actions: () -> Actions = { EmptyView() }
    ) {
        self.presentation = presentation
        self._state = state
        self.actions = actions()
    }

    var body: some View {
        switch state {
        case .loading, .presenting:
            VStack(spacing: .zero) {
                if showHeading {
                    heading
                        .padding(.bottom, 32.0)
                }
                foremostField
                    .padding(.bottom, isLoading ? 24.0 : 32.0)
                actions
                    .padding(.bottom, 32.0)
                details
                Spacer(minLength: 32.0)
            }
            .redacted(if: isLoading)
            .animation(.easeInOut(duration: 0.35), value: state)
        case let .error(error, retryAction):
            ErrorView(
                systemImage: error.image.rawValue,
                title: error.localizedTitle,
                description: error.localizedDescription,
                retryAction: retryAction
            )
        }
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
                ForEach(Presentation.fieldMetadata, id: \.id) { (_, key) in
                    DetailsFieldView(
                        key: key.rawValue,
                        value: .init(presentation.valuePlaceholder(for: key)),
                        badge: presentation.badge(for: key)
                    )
                }
            case let .presenting(fieldValue, _):
                ForEach(Presentation.fieldMetadata, id: \.id) { (_, key) in
                    let fieldValue = fieldValue(key)
                    if fieldValue.characters.isEmpty, let emptyValueString {
                        DetailsFieldView(
                            key: key.rawValue,
                            value: emptyValueString,
                            badge: presentation.badge(for: key),
                            valueColor: .mediumGray
                        )
                    } else {
                        DetailsFieldView(
                            key: key.rawValue,
                            value: fieldValue,
                            badge: presentation.badge(for: key)
                        )
                    }
                }
            case .error:
                EmptyView()
            }
        }
        .padding(.all, 16.0)
        .background(.backgroundGray)
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
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
            case .error:
                EmptyView()
            }
        }
        .padding(.horizontal, 8.0)
        .padding(.vertical, 16.0)
        .background(.backgroundGray)
        .clipShape(RoundedRectangle(cornerRadius: 6.0))
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
        case .error:
            return false
        }
    }

    var headingTitleKey: LocalizedStringKey? {
        switch state {
        case .loading:
            return presentation.loadingTitleKey
        case .presenting:
            return presentation.presentingTitleKey
        case .error:
            return .none
        }
    }

    var headingDescriptionKey: LocalizedStringKey? {
        switch state {
        case .loading:
            return presentation.loadingDescriptionKey
        case .presenting, .error:
            return .none
        }
    }

    var foremostFieldKey: LocalizedStringKey { presentation.foremostFieldKey.rawValue }

    var foremostFieldValue: AttributedString {
        let key = presentation.foremostFieldKey
        switch state {
        case .loading:
            return .init(presentation.valuePlaceholder(for: key))
        case let .presenting(fieldValue, _):
            return fieldValue(key)
        case .error:
            return ""
        }
    }

    var detailsHeaderKey: LocalizedStringKey { presentation.detailsHeaderKey }

    var emptyValueString: AttributedString? { presentation.emptyValueString }

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
        private let value: AttributedString
        private let badge: Badge?
        private let valueColor: Color

        init(
            key: LocalizedStringKey,
            value: AttributedString,
            badge: Badge?,
            valueColor: Color = .extraDarkGray
        ) {
            self.key = key
            self.value = value
            self.badge = badge
            self.valueColor = valueColor
        }

        var body: some View {
            VStack(spacing: 4.0) {
                Group {
                    title
                    Text(value)
                        .font(.inter(size: 14.0))
                        .kerning(0.14)
                        .foregroundStyle(valueColor)
                }
                .tint(.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }

        @ViewBuilder
        private var title: some View {
            HStack(spacing: 4.0) {
                Group {
                    if let badgeTitle {
                        Text(key)
                            .foregroundColor(.regularGray) +
                        Text(verbatim: " - ")
                            .foregroundColor(.regularGray) +
                        Text(badgeTitle)
                            .foregroundColor(.accent)
                    } else {
                        Text(key)
                            .foregroundStyle(.regularGray)
                    }
                }
                .font(.inter(size: 9.0))
                .kerning(0.27)
                .unredacted()
                if case let .link(_, url) = badge {
                    Link(destination: url) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 11.0, weight: .light))
                            .foregroundStyle(.accent)
                            .unredacted()
                    }
                }
            }
        }

        private var badgeTitle: AttributedString? {
            switch badge {
            case let .plain(title):
                return .init(title)
            case let .link(title, destination):
                guard let title = try? AttributedString(markdown: "[\(title)](\(destination))") else {
                    return .init(title)
                }
                return title
            case .none:
                return .none
            }
        }
    }
}

private extension EventPresentability {

    static var fieldMetadata: [(id: UUID, key: FieldKey)] {
        FieldKey.allCases.map { (.init(), $0) }
    }
}

// MARK: Previews

#Preview("Loading") {
    ScrollView {
        EventDetailsView(
            presentation: .basicResponse,
            state: .constant(.loading)
        )
        .padding(.top, 38.0)
        .padding(.horizontal, 16.0)
    }
}

#Preview("Presenting") {
    ScrollView {
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
                        case .vpn, .factoryReset, .jailbreak, .frida, .locationSpoofing, .highActivity:
                            return ""
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
            ),
            actions: {
                CallToActionView(
                   title: AttributedString(
                       stringLiteral: "Impressed with Fingerprint?"
                   ),
                   description: AttributedString(
                       stringLiteral: "Try free for 14 days, credit card not needed."
                   ),
                   primaryButtonTitle: "Sign up",
                   primaryAction: { print("primaryAction()") },
                   secondaryButtonTitle: "Don’t show again for a week",
                   secondaryAction: { print("secondaryAction()") }
               )
            }
        )
        .padding(.top, 38.0)
        .padding(.horizontal, 16.0)
    }
}

#Preview("Error") {
    EventDetailsView(
        presentation: .basicResponse,
        state: .constant(
            .error(
                .init(
                    image: .exclamationMark,
                    localizedTitle: "Why do we fall Bruce?",
                    localizedDescription: "So that we can learn to pick ourselves up."
                ),
                retryAction: {
                    print("retryAction()")
                }
            )
        )
    )
    .padding(.horizontal, 16.0)
}
