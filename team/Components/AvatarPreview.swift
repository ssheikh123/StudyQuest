import SwiftUI

struct AvatarPreview: View {
    let color: Color
    let accessory: AvatarAccessory

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.22))

            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Circle()
                        .fill(color)
                        .frame(width: 104, height: 104)

                    Image(systemName: accessory.iconName)
                        .font(.title.weight(.bold))
                        .foregroundStyle(accessory.color)
                        .offset(y: -18)

                    HStack(spacing: 22) {
                        Circle().fill(.black).frame(width: 9, height: 9)
                        Circle().fill(.black).frame(width: 9, height: 9)
                    }
                    .offset(y: 42)

                    Capsule()
                        .fill(.black.opacity(0.75))
                        .frame(width: 34, height: 7)
                        .offset(y: 66)
                }

                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(color)
                    .frame(width: 132, height: 76)
                    .overlay(
                        Image(systemName: "atom")
                            .font(.title.weight(.bold))
                            .foregroundStyle(.white.opacity(0.9))
                    )
            }
        }
    }
}
