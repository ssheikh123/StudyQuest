import SwiftUI

struct PlaceholderScreen: View {
    let title: String
    let iconName: String
    let message: String
    let settings: AppAccessibilitySettings

    var body: some View {
        NavigationStack {
            ZStack {
                settings.screenBackground.ignoresSafeArea()

                VStack(spacing: 18) {
                    Image(systemName: iconName)
                        .font(.system(size: 58, weight: .bold))
                        .foregroundStyle(settings.accentColor)
                        .frame(width: 104, height: 104)
                        .background(settings.accentColor.opacity(0.14))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))

                    VStack(spacing: 8) {
                        Text(title)
                            .font(.largeTitle.weight(.bold))
                        Text(message)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle(title)
        }
    }
}
