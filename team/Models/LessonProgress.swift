import Foundation

struct LessonProgress: Codable, Equatable {
    var completedLessonIDs = Set<String>()
    var currentLessonID: String?

    func isCompleted(_ lesson: Lesson) -> Bool {
        completedLessonIDs.contains(lesson.id)
    }

    func completedCount(in subject: Subject, difficulty: LessonDifficulty? = nil) -> Int {
        let lessons = difficulty.map { subject.lessons(for: $0) } ?? subject.lessons
        return lessons.filter { completedLessonIDs.contains($0.id) }.count
    }

    func completionPercentage(in subject: Subject, difficulty: LessonDifficulty? = nil) -> Double {
        let lessons = difficulty.map { subject.lessons(for: $0) } ?? subject.lessons
        guard !lessons.isEmpty else { return 0 }
        return Double(lessons.filter { completedLessonIDs.contains($0.id) }.count) / Double(lessons.count)
    }

    func isDifficultyUnlocked(_ difficulty: LessonDifficulty, in subject: Subject) -> Bool {
        switch difficulty {
        case .beginner:
            return true
        case .intermediate:
            return completionPercentage(in: subject, difficulty: .beginner) >= 1
        case .advanced:
            return completionPercentage(in: subject, difficulty: .intermediate) >= 1
        }
    }

    func isLessonUnlocked(_ lesson: Lesson, in subject: Subject) -> Bool {
        guard isDifficultyUnlocked(lesson.difficulty, in: subject) else { return false }
        let lessons = subject.lessons(for: lesson.difficulty)
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }) else { return false }
        return index == 0 || completedLessonIDs.contains(lessons[index - 1].id)
    }

    func currentLesson(in subjects: [Subject]) -> Lesson? {
        if let currentLessonID,
           let lesson = CurriculumData.lesson(withID: currentLessonID),
           !completedLessonIDs.contains(lesson.id) {
            return lesson
        }

        return subjects.lazy
            .flatMap { subject in subject.beginnerLessons }
            .first { !completedLessonIDs.contains($0.id) } ?? subjects.first?.beginnerLessons.first
    }

    func nextLesson(after lesson: Lesson, in subjects: [Subject]) -> Lesson? {
        guard let subject = subjects.first(where: { $0.id == lesson.subjectID }) else { return nil }
        let lessons = subject.lessons(for: lesson.difficulty)
        guard let index = lessons.firstIndex(where: { $0.id == lesson.id }) else { return nil }
        let nextIndex = lessons.index(after: index)
        return nextIndex < lessons.endIndex ? lessons[nextIndex] : nil
    }
}
