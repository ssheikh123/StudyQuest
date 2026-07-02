import SwiftUI

struct LessonsHomeView: View {
    let xp: Int
    let level: Int
    let completedLessonIDs: Set<String>
    let settings: AppAccessibilitySettings
    let startLesson: (STEMLesson) -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HeaderBand(xp: xp, level: level, settings: settings)

                    Text("STEM Lessons")
                        .font(.title2.weight(.bold))
                        .padding(.horizontal, 18)

                    LazyVStack(spacing: 14) {
                        ForEach(STEMLesson.lessons) { lesson in
                            LessonCard(
                                lesson: lesson,
                                isCompleted: completedLessonIDs.contains(lesson.id),
                                settings: settings,
                                startLesson: { startLesson(lesson) }
                            )
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
