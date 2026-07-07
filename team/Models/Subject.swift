import SwiftUI

struct Subject: Identifiable {
    let id: String
    let title: String
    let iconName: String
    let color: Color
    let lessons: [Lesson]

    func lessons(for difficulty: LessonDifficulty) -> [Lesson] {
        lessons
            .filter { $0.difficulty == difficulty }
            .sorted { $0.order < $1.order }
    }

    var beginnerLessons: [Lesson] {
        lessons(for: .beginner)
    }
}
