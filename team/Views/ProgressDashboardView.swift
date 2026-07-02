import SwiftUI

struct ProgressDashboardView: View {
    let xp: Int
    let level: Int
    let completedCount: Int
    let totalLessons: Int
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings

    private var completionProgress: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedCount) / Double(totalLessons)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                        .frame(width: 110, height: 110)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Level \(level)")
                            .font(.title.weight(.bold))
                        Text("\(xp) total XP")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("\(completedCount) of \(totalLessons) lessons complete")
                            .font(.subheadline.weight(.semibold))
                    }

                    Spacer()
                }
                .padding(18)
                .background(settings.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))

                SkillProgressRow(title: "Lesson Progress", value: completionProgress, color: settings.colorblindMode ? .teal : .green)
                SkillProgressRow(title: "Science", value: skillValue(for: "Science"), color: STEMLesson.color(for: "Science", colorblindMode: settings.colorblindMode))
                SkillProgressRow(title: "Technology", value: skillValue(for: "Technology"), color: STEMLesson.color(for: "Technology", colorblindMode: settings.colorblindMode))
                SkillProgressRow(title: "Engineering", value: skillValue(for: "Engineering"), color: STEMLesson.color(for: "Engineering", colorblindMode: settings.colorblindMode))
                SkillProgressRow(title: "Math", value: skillValue(for: "Math"), color: STEMLesson.color(for: "Math", colorblindMode: settings.colorblindMode))
            }
            .padding(18)
        }
        .background(settings.screenBackground)
        .navigationTitle("Progress")
    }

    private func skillValue(for category: String) -> Double {
        let lessonsInCategory = STEMLesson.lessons.filter { $0.category == category }.count
        guard lessonsInCategory > 0 else { return 0 }
        let completedEstimate = min(completedCount, lessonsInCategory)
        return Double(completedEstimate) / Double(lessonsInCategory)
    }
}
