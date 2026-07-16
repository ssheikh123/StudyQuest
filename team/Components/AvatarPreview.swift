import SwiftUI

struct AvatarPreview: View {
    let color: Color
    let accessory: AvatarAccessory
    var contentScale: CGFloat = 0.74
    var reduceMotion = false

    var body: some View {
        GeometryReader { proxy in
            AvatarView(
                skinColor: Color(red: 0.93, green: 0.68, blue: 0.48),
                shirtColor: color,
                accessory: accessory,
                reduceMotion: reduceMotion
            )
            .scaleEffect(contentScale)
            .frame(width: proxy.size.width, height: proxy.size.height)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .clipped()
    }
}
