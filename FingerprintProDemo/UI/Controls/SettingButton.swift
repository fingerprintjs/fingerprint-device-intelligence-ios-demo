import SwiftUI

extension SettingButton {

    enum AccessoryType {
        case disclosureIndicator(textKey: LocalizedStringKey? = .none)
    }
}

struct SettingButton: View {

    private let titleKey: LocalizedStringKey
    private let systemImage: String
    private let accessoryType: AccessoryType?
    private let action: @MainActor () -> Void

    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        accessoryType: AccessoryType? = .none,
        action: @escaping @MainActor () -> Void
    ) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self.accessoryType = accessoryType
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: .zero) {
                Image(systemName: systemImage)
                    .font(.system(size: 17.0))
                    .foregroundStyle(.regularGray)
                    .padding(.trailing, 16.0)
                Text(titleKey)
                    .foregroundStyle(.extraDarkGray)
                if let accessoryType {
                    Spacer(minLength: 8.0)
                    if let textKey = accessoryType.textKey {
                        Text(textKey)
                            .foregroundStyle(.mediumGray)
                            .padding(.trailing, 12.0)
                    }
                    Image(systemName: accessoryType.systemImage)
                        .foregroundStyle(.semiLightGray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.backgroundWhite)
            .font(.inter(size: 16.0))
            .kerning(0.16)
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.backgroundWhite)
    }
}

private extension SettingButton.AccessoryType {

    var systemImage: String {
        switch self {
        case .disclosureIndicator: "chevron.right"
        }
    }

    var textKey: LocalizedStringKey? {
        switch self {
        case let .disclosureIndicator(value): value
        }
    }
}

// MARK: Previews

#Preview {
    List {
        SettingButton(
            "API Keys",
            systemImage: "key.horizontal",
            accessoryType: .disclosureIndicator(textKey: "Off"),
            action: {
                print("customApiKeys()")
            }
        )
        SettingButton(
            "Write a Review",
            systemImage: "star",
            action: {
                print("writeReview()")
            }
        )
        SettingButton(
            "Privacy Policy",
            systemImage: "hand.raised",
            action: {
                print("privacyPolicy()")
            }
        )
        SettingButton(
            "Developer",
            systemImage: "hammer",
            accessoryType: .disclosureIndicator(),
            action: {
                print("developer()")
            }
        )
    }
    .background(.backgroundGray)
    .scrollContentBackground(.hidden)
}
