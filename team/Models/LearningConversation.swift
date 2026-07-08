import Foundation

struct LearningConversation: Codable, Equatable {
    var messages: [LearningMessage] = [
        LearningMessage(role: .assistant, text: "Hi! Ask me for a hint, an easier example, or help understanding a lesson.")
    ]
}
