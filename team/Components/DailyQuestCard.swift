import SwiftUI

struct DailyQuestCard: View {
    let quest: DailyQuest
    let settings: AppAccessibilitySettings
    let claim: () -> Void

    private var iconName: String {
        switch quest.kind {
        case .completeLessons: return "books.vertical.fill"
        case .earnXP: return "bolt.fill"
        case .answerQuestions: return "checkmark.bubble.fill"
        case .completeSubjectLesson: return "target"
        case .reachLevel: return "star.fill"
        case .earnBadge: return "trophy.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(quest.completed ? AppTheme.greenSuccess : settings.accentColor)
                    .frame(width: 46, height: 46)
                    .background((quest.completed ? AppTheme.greenSuccess : settings.accentColor).opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))

                VStack(alignment: .leading, spacing: 3) {
                    Text(quest.title)
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text(quest.description)
                        .font(.studyQuest(.caption, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }

                Spacer()
            }

            if quest.completed {
                Label(quest.claimed ? "Claimed" : "Complete", systemImage: quest.claimed ? "checkmark.seal.fill" : "checkmark.circle.fill")
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .foregroundStyle(quest.claimed ? settings.secondaryText : AppTheme.greenSuccess)
            } else {
                ProgressBar(value: quest.progressFraction, tint: settings.accentColor, minimumFillWidth: 10)
                    .frame(height: 10)
                Text("\(quest.progress) / \(quest.goal)")
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(settings.secondaryText)
            }

            HStack {
                Label("+\(quest.rewardXP) XP", systemImage: "bolt.fill")
                Label("+\(quest.rewardCoins)", systemImage: "circle.hexagongrid.fill")
                Spacer()
                if quest.completed && !quest.claimed {
                    Button(action: claim) {
                        Text("Claim Reward")
                            .font(.studyQuest(.caption, weight: .bold))
                            .foregroundStyle(settings.darkMode ? Color(red: 0.17, green: 0.08, blue: 0.42) : Color.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0) : AppTheme.primary.opacity(0.18))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .studyQuestButtonFeedback()
                }
            }
            .font(.studyQuest(.caption, weight: .bold))
            .foregroundStyle(settings.accentColor)
        }
        .padding(16)
        .studyQuestCard(settings: settings, radius: AppTheme.fieldRadius)
    }
}
