import Foundation

enum AvatarManager {
    static func cosmetics(profile: UserProfile, wallet: RewardsWallet) -> [AvatarCosmetic] {
        RewardsCatalog.avatarCosmeticItems.map { item in
            AvatarCosmetic(
                id: item.id,
                name: item.title,
                icon: item.iconName,
                category: item.category,
                coinCost: item.cost,
                color: item.color,
                avatarColor: item.avatarColor,
                avatarAccessory: item.avatarAccessory,
                unlocked: wallet.owns(item),
                equipped: isEquipped(item, profile: profile)
            )
        }
    }

    static func starterItemIDs(color: AvatarColor, accessory: AvatarAccessory) -> Set<String> {
        Set(RewardsCatalog.avatarCosmeticItems.compactMap { item in
            if item.avatarColor == color || item.avatarAccessory == accessory {
                return item.id
            }
            return nil
        })
    }

    static func grantStarterEquipment(profile: UserProfile, wallet: inout RewardsWallet) {
        wallet.purchasedShopItemIDs.formUnion(starterItemIDs(color: profile.avatarColor, accessory: profile.avatarAccessory))
    }

    static func item(for cosmetic: AvatarCosmetic) -> ShopItem? {
        RewardsCatalog.avatarCosmeticItems.first { $0.id == cosmetic.id }
    }

    private static func isEquipped(_ item: ShopItem, profile: UserProfile) -> Bool {
        item.avatarColor == profile.avatarColor || item.avatarAccessory == profile.avatarAccessory
    }
}
