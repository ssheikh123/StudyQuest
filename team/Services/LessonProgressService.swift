struct LessonProgressService {
    @discardableResult
    static func complete(
        _ lesson: Lesson,
        progress: inout LessonProgress,
        xp: inout Int,
        learningFocusSubjectID: String?,
        subjects: [Subject] = CurriculumData.subjects
    ) -> Bool {
        guard !progress.completedLessonIDs.contains(lesson.id) else { return false }

        progress.completedLessonIDs.insert(lesson.id)
        xp += xpReward(for: lesson, learningFocusSubjectID: learningFocusSubjectID)
        progress.currentLessonID = progress.nextLesson(after: lesson, in: subjects)?.id
        return true
    }

    static func xpReward(for lesson: Lesson, learningFocusSubjectID: String?) -> Int {
        guard lesson.subjectID == learningFocusSubjectID else { return lesson.xpReward }
        return Int((Double(lesson.xpReward) * 1.1).rounded())
    }
}
