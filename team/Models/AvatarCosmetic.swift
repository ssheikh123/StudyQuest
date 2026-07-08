import SwiftUI

struct AvatarCosmetic: Identifiable {
    let id: String
    let name: String
    let icon: String
    let category: ShopCategory
    let coinCost: Int
    let color: Color
    let avatarColor: AvatarColor?
    let avatarAccessory: AvatarAccessory?
    let unlocked: Bool
    let equipped: Bool
}
