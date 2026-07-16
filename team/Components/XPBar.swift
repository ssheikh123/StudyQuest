import SwiftUI

struct XPBar: View {
    let xp: Int
    let settings: AppAccessibilitySettings

    private var progress: Double {
        Leveling.progressToNextLevel(for: xp)
    }

    private var xpIntoLevel: Int {
        Leveling.xpIntoCurrentLevel(for: xp)
    }

    private var xpUntilNextLevel: Int {
        Leveling.xpUntilNextLevel(for: xp)
    }

    private var xpRequiredForLevel: Int {
        Leveling.xpRequiredForCurrentLevel(for: xp)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("EXP until next level", systemImage: "bolt.fill")
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Spacer()
                Text("\(xpUntilNextLevel) left")
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(settings.secondaryText)
            }

            ProgressBar(value: progress, tint: AppTheme.primary, minimumFillWidth: 12)
                .frame(height: 12)
                .accessibilityLabel("Experience progress to next level")
                .accessibilityValue("\(xpIntoLevel) of \(xpRequiredForLevel) experience")
        }
    }
}
