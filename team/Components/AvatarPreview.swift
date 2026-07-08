import SwiftUI

struct AvatarPreview: View {
    let color: Color
    let accessory: AvatarAccessory

    var body: some View {
        AvatarView(
            skinColor: Color(red: 0.93, green: 0.68, blue: 0.48),
            shirtColor: color,
            accessory: accessory
        )
    }
}
