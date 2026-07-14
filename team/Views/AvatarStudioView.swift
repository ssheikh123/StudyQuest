import SwiftUI

struct AvatarStudioView: View {
    let xp: Int
    let level: Int
    let settings: AppAccessibilitySettings
    @Binding var selectedColor: AvatarColor
    @Binding var selectedAccessory: AvatarAccessory
    @Binding var wallet: RewardsWallet

    @State private var message: AvatarStudioMessage?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var profile: UserProfile {
        var profile = UserProfile()
        profile.avatarColor = selectedColor
        profile.avatarAccessory = selectedAccessory
        return profile
    }

    private var cosmetics: [AvatarCosmetic] {
        AvatarManager.cosmetics(profile: profile, wallet: wallet)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 14) {
                    AvatarPreview(color: selectedColor.color, accessory: selectedAccessory)
                        .frame(width: 190, height: 190)

                    Text("Level \(level) Explorer")
                        .font(.title2.weight(.bold))

                    Text("\(xp) XP unlocks your science style.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(22)
                .studyQuestCard(settings: settings, radius: AppTheme.cornerRadius)

                cosmeticSection(title: "Equipped", items: cosmetics.filter(\.equipped))
                cosmeticSection(title: "Unlocked", items: cosmetics.filter { $0.unlocked && !$0.equipped })
                cosmeticSection(title: "Locked", items: cosmetics.filter { !$0.unlocked })
            }
            .padding(18)
        }
        .background(settings.alternateScreenBackground)
        .navigationTitle("Avatar Studio")
        .alert(item: $message) { message in
            Alert(
                title: Text(message.title),
                message: Text(message.body),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func cosmeticSection(title: String, items: [AvatarCosmetic]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title)

            if items.isEmpty {
                Text("No items here yet.")
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .studyQuestCard(settings: settings, radius: AppTheme.fieldRadius)
            } else {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(items) { cosmetic in
                        AvatarCosmeticCard(cosmetic: cosmetic, settings: settings) {
                            handle(cosmetic)
                        }
                    }
                }
            }
        }
    }

    private func handle(_ cosmetic: AvatarCosmetic) {
        guard cosmetic.unlocked else {
            purchase(cosmetic)
            return
        }

        equip(cosmetic)
    }

    private func purchase(_ cosmetic: AvatarCosmetic) {
        guard let item = AvatarManager.item(for: cosmetic) else { return }

        switch RewardsService.purchase(item, wallet: &wallet) {
        case .purchased:
            FeedbackManager.purchase()
            equip(cosmetic)
            message = AvatarStudioMessage(title: "Unlocked", body: "\(cosmetic.name) is now available.")
        case .alreadyOwned:
            equip(cosmetic)
        case .insufficientCoins:
            message = AvatarStudioMessage(title: "Not Enough Coins", body: "Earn more coins from lessons or daily rewards to unlock this item.")
        }
    }

    private func equip(_ cosmetic: AvatarCosmetic) {
        if let color = cosmetic.avatarColor {
            if selectedColor != color {
                selectedColor = color
                FeedbackManager.equipCosmetic()
            }
            return
        }

        if let accessory = cosmetic.avatarAccessory {
            if selectedAccessory != accessory {
                selectedAccessory = accessory
                FeedbackManager.equipCosmetic()
            }
            return
        }

        message = AvatarStudioMessage(title: "Purchased Item", body: "This cosmetic is unlocked, but avatar display support is coming soon.")
    }
}

private struct AvatarStudioMessage: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}
