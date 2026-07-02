import SwiftUI

struct HeaderBand: View {
    let xp: Int
    let level: Int
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.25))
                    Image(systemName: "atom")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 82, height: 82)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Level \(level)")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Text("\(xp) XP earned")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.88))
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Next level")
                    Spacer()
                    Text("\(xp % 100)/100 XP")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)

                ProgressBar(
                    value: Leveling.progressToNextLevel(for: xp),
                    tint: .white,
                    backgroundOpacity: 0.25,
                    minimumFillWidth: 12
                )
                .frame(height: 12)
            }
        }
        .padding(20)
        .background(AppTheme.brandGradient(colorblindMode: settings.colorblindMode))
    }
}
