import Foundation

struct ProgressData: Codable, Equatable {
    var xp = 0
    var lessonProgress = LessonProgress()

    var level: Int {
        Leveling.level(for: xp)
    }
}
