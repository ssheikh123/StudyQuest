import SwiftUI

struct LaunchScreenView: View {
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings
    let start: () -> Void

    var body: some View {
        ZStack {
            launchBackground

            VStack(spacing: 26) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(settings.darkMode ? 0.12 : 0.22))
                        .frame(width: 132, height: 132)

                    Image(systemName: "atom")
                        .font(.system(size: 66, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 8) {
                    Text("StudyQuest")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("STEM learning for curious minds")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.86))
                        .multilineTextAlignment(.center)
                }

                AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                    .frame(width: 168, height: 168)
                    .background(.white.opacity(settings.darkMode ? 0.08 : 0.16))
                    .clipShape(Circle())
                    .accessibilityLabel("User avatar")

                Button(action: start) {
                    Label("Start Learning", systemImage: "play.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(settings.accentColor)
                        .frame(maxWidth: 260)
                        .padding(.vertical, 16)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                }
                .accessibilityLabel("Start Learning")
            }
            .padding(28)
        }
        .ignoresSafeArea()
    }

    private var launchBackground: some View {
        AppTheme.brandGradient(colorblindMode: settings.colorblindMode)
            .overlay(settings.darkMode ? Color.black.opacity(0.28) : Color.clear)
    }
}
