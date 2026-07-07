import SwiftUI

struct ProgressDashboardView: View {
    let xp: Int
    let level: Int
    let progress: LessonProgress
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings

    private var completedCount: Int {
        progress.completedLessonIDs.count
    }

    private var totalLessons: Int {
        CurriculumData.beginnerLessons.count
    }

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
                        Text("\(completedCount) of \(totalLessons) beginner lessons complete")
                            .font(.subheadline.weight(.semibold))
                    }

                    Spacer()
                }
                .padding(18)
                .background(settings.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))

                SkillProgressRow(title: "Beginner Progress", value: completionProgress, color: settings.colorblindMode ? .teal : .green)

                ForEach(CurriculumData.subjects) { subject in
                    SkillProgressRow(
                        title: subject.title,
                        value: progress.completionPercentage(in: subject, difficulty: .beginner),
                        color: settings.colorblindMode ? Lesson.colorblindColor(for: subject.id) : subject.color
                    )
                }
            }
            .padding(18)
        }
        .background(settings.screenBackground)
        .navigationTitle("Progress")
    }
}
