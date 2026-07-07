import SwiftUI

struct XPBar: View {
    let xp: Int
    let settings: AppAccessibilitySettings

    private var progress: Double {
        Leveling.progressToNextLevel(for: xp)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("XP", systemImage: "bolt.fill")
                    .font(.studyQuest(.subheadline, weight: .bold))
                Spacer()
                Text("\(xp % 100)/100")
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(settings.secondaryText)
            }

            ProgressBar(value: progress, tint: AppTheme.primary, minimumFillWidth: 12)
                .frame(height: 12)
        }
    }
}
