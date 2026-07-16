import SwiftUI

struct SubjectCard: View {
    let subject: Subject
    let completedCount: Int
    let settings: AppAccessibilitySettings

    private var beginnerCount: Int {
        subject.beginnerLessons.count
    }

    private var progress: Double {
        guard beginnerCount > 0 else { return 0 }
        return Double(completedCount) / Double(beginnerCount)
    }

    private var subjectColor: Color {
        AppTheme.subjectColor(for: subject.id, colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Image(systemName: subject.iconName)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background(subjectColor.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius))

                VStack(alignment: .leading, spacing: 6) {
                    Text(subject.title)
                        .font(.studyQuest(.title2, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text("\(beginnerCount) Beginner Lessons")
                        .font(.studyQuest(.subheadline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Beginner completion")
                    Spacer()
                    Text("\(completedCount)/\(beginnerCount)")
                }
                .font(.studyQuest(.caption, weight: .bold))
                .foregroundStyle(settings.secondaryText)

                ProgressBar(value: progress, tint: subjectColor, minimumFillWidth: 12)
                    .frame(height: 12)
            }

            HStack(spacing: 10) {
                Label("Intermediate", systemImage: "lock.fill")
                Label("Advanced", systemImage: "lock.fill")
            }
            .font(.studyQuest(.caption, weight: .bold))
            .foregroundStyle(settings.secondaryText)
        }
        .padding(20)
        .studyQuestCard(settings: settings)
    }
}
