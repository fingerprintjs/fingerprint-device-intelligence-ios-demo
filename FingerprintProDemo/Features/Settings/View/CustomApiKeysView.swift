import SwiftUI

struct CustomApiKeysView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var showInvalidKeysAlert: Bool = false
    @FocusState private var focusedField: FieldKey?

    @StateObject private var viewModel: CustomApiKeysViewModel

    init(viewModel: CustomApiKeysViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            headerSection
            if showInputFields {
                publicKeySection
                secretKeySection
                regionSection
            }
        }
        .background(.backgroundGray)
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("API Keys")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            toolbarContent
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
        .alert("Invalid keys!", isPresented: $showInvalidKeysAlert) {
            Button("Continue editing", role: .cancel) {}
            Button("Discard changes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text(
                """
                Your changes will not be saved. The app will continue \
                to use the previously saved API keys.
                """
            )
        }
        .tint(.accent)
    }
}

private extension CustomApiKeysView {

    @ViewBuilder
    var headerSection: some View {
        section(
            description: """
                When enabled, the app will use your API keys to make all the requests. \
                These requests will count towards your monthly allowance.
                """,
            header: {
                Text(
                    AttributedString(
                        localized: """
                            You can obtain API keys by logging in to \
                            [fingerprint.com](\(C.URLs.signIn, format: .url)).
                            """
                    )
                )
                .font(.inter(size: 14.0))
                .kerning(0.14)
                .foregroundStyle(.gray900)
                .textCase(.none)
                .padding(.top, 8.0)
                .padding(.bottom, 20.0)
            }
        ) {
            Toggle("Use your API keys", isOn: $viewModel.apiKeysEnabled.animation())
                .tint(.accent)
                .foregroundStyle(.gray900)
        }
    }

    @ViewBuilder
    var publicKeySection: some View {
        section(
            titled: "Public API Key",
            description: "A public key is required to get a visitor ID."
        ) {
            textField(.publicKey)
        }
    }

    @ViewBuilder
    var secretKeySection: some View {
        section(
            titled: "Secret API Key",
            description: "A secret key is required to fetch Smart Signals."
        ) {
            textField(.secretKey)
        }
    }

    @ViewBuilder
    var regionSection: some View {
        section(description: "Specify the server region of your Fingerprint app.") {
            regionPicker
        }
    }

    @ViewBuilder
    func section<Header: View, Content: View>(
        description descriptionKey: LocalizedStringKey,
        @ViewBuilder header: () -> Header = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) -> some View {
        Section(
            content: content,
            header: header,
            footer: {
                description(descriptionKey)
            }
        )
    }

    @ViewBuilder
    func section<Content: View>(
        titled titleKey: LocalizedStringKey,
        description descriptionKey: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Section(
            content: content,
            header: {
                Text(titleKey)
                    .font(.inter(size: 12.0))
                    .kerning(0.36)
                    .foregroundStyle(.gray500)
            },
            footer: {
                description(descriptionKey)
            }
        )
    }

    @ViewBuilder
    func description(_ key: LocalizedStringKey) -> some View {
        Text(key)
            .font(.inter(size: 14.0))
            .kerning(0.14)
            .foregroundStyle(.gray500)
            .padding(.top, 4.0)
    }

    @ViewBuilder
    func textField(_ fieldKey: FieldKey) -> some View {
        TextField(titleKey(for: fieldKey), text: text(for: fieldKey))
            .focused($focusedField, equals: fieldKey)
            .keyboardType(.asciiCapable)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .disabled(!viewModel.apiKeysEnabled)
    }

    @ViewBuilder
    var regionPicker: some View {
        LabeledContent {
            // The Picker control is a bit buggy and likes to "jump" when
            // the selection is changed to a longer value (i.e. "EU" to
            // "Global (US)"). Just another SwiftUI thing ¯\_(ツ)_/¯
            Picker(selection: $viewModel.region) {
                ForEach(PresentableRegion.allCases, id: \.self) {
                    Text($0.description)
                }
            } label: {
                EmptyView()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .pickerStyle(.menu)
            .labelsHidden()
            .tint(.gray900)
            .disabled(!viewModel.apiKeysEnabled)
        } label: {
            Text("Server Region")
                .font(.inter(size: 16.0))
                .kerning(0.16)
                .foregroundStyle(.gray500)
        }
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: backAction) {
                HStack {
                    Image(systemName: "chevron.backward")
                        .fontWeight(.semibold)
                    Text("Settings")
                }
            }
        }
        ToolbarItemGroup(placement: .keyboard) {
            Group {
                Button(action: focusPreviousField) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canFocusPreviousField)
                Button(action: focusNextField) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canFocusNextField)
            }
            Spacer()
        }
    }
}

private extension CustomApiKeysView {

    var showInputFields: Bool {
        viewModel.apiKeysEnabled
            || !viewModel.publicKey.isEmpty
            || !viewModel.secretKey.isEmpty
    }

    func backAction() {
        guard viewModel.saveApiKeys() else {
            showInvalidKeysAlert = true
            return
        }
        dismiss()
    }
}

private extension CustomApiKeysView {

    enum FieldKey: Int, CaseIterable {
        case publicKey
        case secretKey
    }

    func titleKey(for fieldKey: FieldKey) -> LocalizedStringKey {
        switch fieldKey {
        case .publicKey: "Public Key"
        case .secretKey: "Secret Key"
        }
    }

    func text(for fieldKey: FieldKey) -> Binding<String> {
        switch fieldKey {
        case .publicKey: $viewModel.publicKey
        case .secretKey: $viewModel.secretKey
        }
    }

    var canFocusPreviousField: Bool {
        guard let focusedField else { return false }
        return focusedField.rawValue > 0
    }

    func focusPreviousField() {
        focusedField = focusedField.flatMap {
            FieldKey(rawValue: $0.rawValue - 1) ?? .allCases.last
        }
    }

    var canFocusNextField: Bool {
        guard let focusedField else { return false }
        return focusedField.rawValue < FieldKey.allCases.count - 1
    }

    func focusNextField() {
        focusedField = focusedField.flatMap {
            FieldKey(rawValue: $0.rawValue + 1) ?? .allCases.first
        }
    }
}

// MARK: Previews

#if DEBUG

#Preview {
    NavigationStack {
        CustomApiKeysView(viewModel: .preview)
    }
}

#endif
