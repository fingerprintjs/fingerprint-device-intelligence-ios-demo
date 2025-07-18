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
                foremostItem
                    .padding(.bottom, isLoading ? 24.0 : 32.0)
                actions
                    .padding(.bottom, 32.0)
                details
                Spacer(minLength: 32.0)
            }
            .animation(.easeInOut(duration: 0.35), value: state)
        case let .error(error, action):
            ErrorView(
                systemImage: error.image.rawValue,
                title: error.localizedTitle,
                description: error.localizedDescription,
                buttonTitle: error.actionKind.localizedString,
                action: action
            )
        }
    }
}

@MainActor
private extension EventDetailsView {

    @ViewBuilder
    var heading: some View {
        VStack(spacing: 8.0) {
            Group {
                if let headingTitleKey {
                    Text(headingTitleKey)
                        .font(.inter(size: 24.0, relativeTo: .title, weight: .semibold))
                        .foregroundStyle(.gray900)
                        .lineLimit(1)
                }

                if isLoading, let headingDescriptionKey {
                    Text(headingDescriptionKey)
                        .font(.inter(size: 16.0))
                        .foregroundStyle(.gray500)
                        .lineLimit(3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    var foremostItem: some View {
        VStack(spacing: 4.0) {
            Group {
                Text(foremostItemKey)
                    .font(.inter(size: 12.0))
                    .kerning(0.36)
                    .foregroundStyle(.gray400)

                Text(foremostItemValue)
                    .font(.inter(size: 22.0, weight: .medium))
                    .foregroundStyle(isPresenting ? .accent : .clear)
                    .background(isPresenting ? .clear : .gray100)
                    .cornerRadius(4.0)
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
                .foregroundStyle(.gray400)

            Picker(selection: $detailsDisplayMode.animation()) {
                ForEach(DetailsDisplayMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.segmented)
            .disabled(isLoading)

            if case let .presenting(_, rawDetailsText) = state {
                HStack {
                    Button {
                        sendSupportEmail(with: rawDetailsText)
                    } label: {
                        Label("Attach Raw Response to Email", systemImage: "envelope")
                            .font(.inter(size: 14.0))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                    }
                    .foregroundStyle(.accent)
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8.0)
                .frame(maxWidth: .infinity, alignment: .center)
            }

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
                ForEach(prettifiedItems(keyedValue: .none)) {
                    PrettifiedItemView(item: $0)
                }
            case let .presenting(itemValue, _):
                ForEach(prettifiedItems(keyedValue: itemValue)) {
                    PrettifiedItemView(item: $0)
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
                        Text(JSONSyntaxHighlighter(json: rawDetails).highlighted())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                            .disabled(isLoading)
                    }
                }
                .font(.system(size: 12.0, weight: .regular, design: .monospaced))
                .foregroundStyle(.gray600)
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

@MainActor
private extension EventDetailsView {

    var isLoading: Bool { state == .loading }

    var isPresenting: Bool {
        if case .presenting = state { true } else { false }
    }

    var showHeading: Bool {
        switch state {
        case .loading:
            presentation.loadingTitleKey != .none || presentation.loadingDescriptionKey != .none
        case .presenting:
            presentation.presentingTitleKey != .none
        case .error:
            false
        }
    }

    var headingTitleKey: LocalizedStringKey? {
        switch state {
        case .loading: presentation.loadingTitleKey
        case .presenting: presentation.presentingTitleKey
        case .error: .none
        }
    }

    var headingDescriptionKey: LocalizedStringKey? {
        switch state {
        case .loading: presentation.loadingDescriptionKey
        case .presenting, .error: .none
        }
    }

    var foremostItemKey: LocalizedStringKey { presentation.foremostItemKey.rawValue }

    var foremostItemValue: AttributedString {
        let key = presentation.foremostItemKey
        switch state {
        case .loading:
            return .init(presentation.valuePlaceholder(for: key))
        case let .presenting(itemValue, _):
            let itemValue = itemValue(key)
            if itemValue.characters.isEmpty, let emptyValueString {
                return emptyValueString
            } else {
                return itemValue
            }
        case .error:
            return ""
        }
    }

    var detailsHeaderKey: LocalizedStringKey { presentation.detailsHeaderKey }

    var emptyValueString: AttributedString? { presentation.emptyValueString }

    func lineNumbersString(for text: String) -> String {
        (1 ... text.linesCount)
            .map { "\($0)" }
            .joined(separator: "\n")
    }
}

@MainActor
private extension EventDetailsView {

    enum DetailsDisplayMode: LocalizedStringKey, CaseIterable {
        case prettified = "PRETTIFIED"
        case raw = "RAW"
    }
}

@MainActor
private extension EventDetailsView {

    func prettifiedItems(
        keyedValue: ((Presentation.ItemKey) -> AttributedString)?
    ) -> [PrettifiedItem] {
        Presentation.ItemKey.allCases.map { key in
            let value: AttributedString
            let valueForeground: Color
            let valueBackground: Color
            if let keyedValue = keyedValue?(key) {
                if keyedValue.characters.isEmpty, let emptyValueString {
                    value = emptyValueString
                    valueForeground = .gray500
                } else {
                    value = keyedValue
                    valueForeground = .gray900
                }
                valueBackground = .clear
            } else {
                value = .init(presentation.valuePlaceholder(for: key))
                valueForeground = .clear
                valueBackground = .gray100
            }
            return .init(
                id: key.hashValue,
                key: key.rawValue,
                value: value,
                valueForeground: valueForeground,
                valueBackground: valueBackground,
                badge: presentation.badge(for: key)
            )
        }
    }

    func sendSupportEmail(with rawDetails: String) {
        let subject = "Raw Response Debug Info"
        let body = """
                Hello,

                Please find the raw response below:

                \(rawDetails)
            """
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let mailtoURL = URL(string: "mailto:support@fingerprint.com?subject=\(encodedSubject)&body=\(encodedBody)") {
            UIApplication.shared.open(mailtoURL)
        }
    }

    struct PrettifiedItem: Identifiable {
        let id: Int
        let key: LocalizedStringKey
        let value: AttributedString
        let valueForeground: Color
        let valueBackground: Color
        let badge: Badge?
    }

    struct PrettifiedItemView: View {

        private let item: PrettifiedItem

        init(item: PrettifiedItem) {
            self.item = item
        }

        var body: some View {
            VStack(spacing: 4.0) {
                Group {
                    title
                    Text(item.value)
                        .font(.system(size: 14))
                        .kerning(0.14)
                        .textSelection(.enabled)
                        .foregroundStyle(item.valueForeground)
                        .background(item.valueBackground)
                        .cornerRadius(4.0)
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
                        Text(item.key)
                            .foregroundColor(.gray400)
                            + Text(verbatim: " - ")
                            .foregroundColor(.gray400)
                            + Text(badgeTitle)
                            .foregroundColor(.accent)
                    } else {
                        Text(item.key)
                            .foregroundStyle(.gray400)
                    }
                }
                .font(.inter(size: 9.0))
                .kerning(0.27)
                if case let .link(_, url) = item.badge {
                    Link(destination: url) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 11.0, weight: .light))
                            .foregroundStyle(.accent)
                    }
                }
            }
        }

        private var badgeTitle: AttributedString? {
            switch item.badge {
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
                    itemValue: { key in
                        switch key {
                        case .requestId:
                            "1702058653176.gO9SYo"
                        case .visitorId:
                            "rVC74CiaXVZGVC69OBsP"
                        case .visitorFound:
                            "Yes"
                        case .confidence:
                            "100%"
                        case .vpn, .factoryReset,
                            .jailbreak, .frida,
                            .geolocationSpoofing, .highActivity,
                            .tampering, .mitmAttack:
                            ""
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
}

#Preview("Error") {
    EventDetailsView(
        presentation: .basicResponse,
        state: .constant(
            .error(
                .init(
                    image: .exclamationMark,
                    localizedTitle: "Why do we fall Bruce?",
                    localizedDescription: "So that we can learn to pick ourselves up.",
                    actionKind: .retry
                ),
                action: {
                    print("retryAction()")
                }
            )
        )
    )
    .padding(.horizontal, 16.0)
}
