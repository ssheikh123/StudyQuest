struct LessonProgressService {
    static func complete(_ lesson: STEMLesson, completedLessonIDs: inout Set<String>, xp: inout Int) {
        guard !completedLessonIDs.contains(lesson.id) else { return }

        completedLessonIDs.insert(lesson.id)
        xp += lesson.xpReward
    }
}
