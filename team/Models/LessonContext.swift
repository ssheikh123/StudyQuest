import Foundation

struct LessonContext: Codable, Equatable {
    let subject: String
    let lessonTitle: String
    let difficulty: LessonDifficulty

    init(lesson: Lesson) {
        subject = lesson.subjectTitle
        lessonTitle = lesson.title
        difficulty = lesson.difficulty
    }
}
