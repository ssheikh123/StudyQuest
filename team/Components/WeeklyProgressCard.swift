import SwiftUI

struct WeeklyProgressCard: View {
    let weeklyProgress: WeeklyProgress
    let goalKind: WeeklyGoalKind
    let goalTarget: Int
    let goalCompleted: Int
    let settings: AppAccessibilitySettings
    let selectGoalKind: (WeeklyGoalKind) -> Void
    let adjustGoalTarget: (Int) -> Void
    let resetGoal: () -> Void

    private var goalProgress: Double {
        guard goalTarget > 0 else { return 0 }
        return min(Double(goalCompleted) / Double(goalTarget), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Weekly Progress")

            HStack(spacing: 12) {
                WeeklyMetricView(value: "\(weeklyProgress.lessonsCompleted)", title: "Lessons", iconName: "books.vertical.fill", settings: settings)
                WeeklyMetricView(value: "\(weeklyProgress.xpEarned)", title: "XP", iconName: "bolt.fill", settings: settings)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Weekly goal")
                            .font(.studyQuest(.subheadline, weight: .bold))
                            .foregroundStyle(settings.primaryText)
                        Text("Choose what progress means this week")
                            .font(.studyQuest(.caption, weight: .semibold))
                            .foregroundStyle(settings.secondaryText)
                    }

                    Spacer(minLength: 0)

                    Button("Reset") {
                        resetGoal()
                    }
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(purpleControlText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(purpleControlBackground)
                    .clipShape(Capsule())
                    .studyQuestButtonFeedback()
                }

                HStack(spacing: 8) {
                    ForEach(WeeklyGoalKind.allCases) { option in
                        Button {
                            selectGoalKind(option)
                        } label: {
                            Label(option.title, systemImage: option.iconName)
                                .font(.studyQuest(.caption, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 9)
                        }
                        .foregroundStyle(goalKind == option ? purpleControlText : settings.primaryText)
                        .background(goalKind == option ? purpleControlBackground : settings.screenBackground)
                        .clipShape(Capsule())
                        .studyQuestButtonFeedback()
                        .accessibilityLabel("Set weekly goal type to \(option.title)")
                    }
                }

                HStack(spacing: 12) {
                    goalStepperButton(systemName: "minus", isDisabled: goalTarget <= 1) {
                        adjustGoalTarget(-1)
                    }

                    VStack(spacing: 2) {
                        Text("Goal")
                            .font(.studyQuest(.caption2, weight: .bold))
                            .foregroundStyle(settings.secondaryText)
                            .textCase(.uppercase)
                        Text("\(goalTarget) \(goalKind.unit)")
                            .font(.studyQuest(.title3, weight: .bold))
                            .foregroundStyle(settings.primaryText)
                    }
                    .frame(maxWidth: .infinity)

                    goalStepperButton(systemName: "plus", isDisabled: goalTarget >= 12) {
                        adjustGoalTarget(1)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(goalCompleted) of \(goalTarget) \(goalKind.unit)")
                            .font(.studyQuest(.caption, weight: .bold))
                            .foregroundStyle(settings.primaryText)
                        Spacer()
                        Text("\(Int(goalProgress * 100))%")
                            .font(.studyQuest(.caption, weight: .bold))
                            .foregroundStyle(settings.secondaryText)
                    }

                    ProgressBar(value: goalProgress, tint: AppTheme.greenSuccess, minimumFillWidth: 12)
                        .frame(height: 12)
                }
            }
            .padding(14)
            .background(settings.screenBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius, style: .continuous))
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }

    private var purpleControlText: Color {
        settings.darkMode ? Color(red: 0.17, green: 0.08, blue: 0.42) : .black
    }

    private var purpleControlBackground: Color {
        settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0) : AppTheme.primary.opacity(0.18)
    }

    private func goalStepperButton(systemName: String, isDisabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.headline.weight(.bold))
                .frame(width: 40, height: 40)
        }
        .foregroundStyle(settings.primaryText)
        .background(AppTheme.cardBackground(darkMode: settings.darkMode))
        .clipShape(Circle())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.45 : 1)
        .studyQuestButtonFeedback()
    }
}

enum WeeklyGoalKind: String, CaseIterable, Identifiable {
    case lessons
    case levels

    var id: String { rawValue }

    var title: String {
        switch self {
        case .lessons:
            return "Lessons"
        case .levels:
            return "Levels"
        }
    }

    var unit: String {
        switch self {
        case .lessons:
            return "lessons"
        case .levels:
            return "levels"
        }
    }

    var iconName: String {
        switch self {
        case .lessons:
            return "book.closed.fill"
        case .levels:
            return "star.fill"
        }
    }
}

private struct WeeklyMetricView: View {
    let value: String
    let title: String
    let iconName: String
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: iconName)
                .font(.headline.weight(.bold))
                .foregroundStyle(settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0) : .black)
            Text(value)
                .font(.studyQuest(.title2, weight: .bold))
                .foregroundStyle(settings.primaryText)
            Text(title)
                .font(.studyQuest(.caption, weight: .semibold))
                .foregroundStyle(settings.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(settings.darkMode ? Color(red: 0.86, green: 0.80, blue: 1.0).opacity(0.14) : AppTheme.primary.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
    }
}
