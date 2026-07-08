import Foundation

struct LessonContext: Equatable {
    let subject: String
    let lessonTitle: String
    let difficulty: LessonDifficulty

    init(lesson: Lesson) {
        subject = lesson.subjectTitle
        lessonTitle = lesson.title
        difficulty = lesson.difficulty
    }
}
