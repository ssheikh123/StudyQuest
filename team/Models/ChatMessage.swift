import Foundation

enum ChatSender: String, Codable {
    case student
    case assistant
    case system
}

struct ChatMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let sender: ChatSender
    var content: String
    let timestamp: Date
    var deliveryState: DeliveryState

    enum DeliveryState: String, Codable, Equatable {
        case sent
        case failed
    }

    init(
        id: UUID = UUID(),
        sender: ChatSender,
        content: String,
        timestamp: Date = Date(),
        deliveryState: DeliveryState = .sent
    ) {
        self.id = id
        self.sender = sender
        self.content = content
        self.timestamp = timestamp
        self.deliveryState = deliveryState
    }
}
