import Foundation

struct UserProfile: Codable, Equatable {
    var userName = "Alex"
    var learningFocusSubjectID = "algebra"
    var avatarColor = AvatarColor.sky
    var avatarAccessory = AvatarAccessory.stars
    var hasCompletedOnboarding = false

    var learningFocusSubject: Subject? {
        CurriculumData.subjects.first { $0.id == learningFocusSubjectID }
    }
}
