import SwiftUI

struct LessonsHomeView: View {
    let xp: Int
    let level: Int
    let progress: LessonProgress
    let settings: AppAccessibilitySettings
    let startLesson: (Lesson) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBand(xp: xp, level: level, settings: settings)

                    Text("Learning Paths")
                        .font(.title2.weight(.bold))
                        .padding(.horizontal, 18)

                    LazyVStack(spacing: 14) {
                        ForEach(CurriculumData.subjects) { subject in
                            NavigationLink {
                                DifficultySelectionView(
                                    subject: subject,
                                    progress: progress,
                                    settings: settings,
                                    startLesson: startLesson
                                )
                            } label: {
                                SubjectCard(
                                    subject: subject,
                                    completedCount: progress.completedCount(in: subject, difficulty: .beginner),
                                    settings: settings
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 24)
                }
            }
            .background(settings.screenBackground)
            .navigationTitle("StudyQuest")
        }
    }
}
