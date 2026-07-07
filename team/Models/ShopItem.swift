import SwiftUI

struct ShopItem: Identifiable {
    let id: String
    let title: String
    let category: ShopCategory
    let iconName: String
    let cost: Int
    let color: Color
    let avatarColor: AvatarColor?
    let avatarAccessory: AvatarAccessory?

    init(
        id: String,
        title: String,
        category: ShopCategory,
        iconName: String,
        cost: Int,
        color: Color,
        avatarColor: AvatarColor? = nil,
        avatarAccessory: AvatarAccessory? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.iconName = iconName
        self.cost = cost
        self.color = color
        self.avatarColor = avatarColor
        self.avatarAccessory = avatarAccessory
    }
}
