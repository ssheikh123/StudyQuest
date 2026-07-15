import Foundation

struct Conversation: Identifiable, Codable, Equatable {
    let id: UUID
    let lessonID: String
    let createdDate: Date
    var updatedDate: Date
    var messages: [ChatMessage]

    init(
        id: UUID = UUID(),
        lessonID: String,
        createdDate: Date = Date(),
        updatedDate: Date = Date(),
        messages: [ChatMessage] = []
    ) {
        self.id = id
        self.lessonID = lessonID
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.messages = messages
    }
}
