import Foundation

final class ConversationManager {
    static let shared = ConversationManager()

    private let storageKey = "studyquest.ai.conversations.v2"
    private let legacyStorageKey = "studyquest.ai.conversations.v1"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var conversationsByLessonID: [String: Conversation]

    private init() {
        conversationsByLessonID = Self.loadConversations(
            storageKey: storageKey,
            legacyStorageKey: legacyStorageKey,
            decoder: decoder
        )
    }

    func conversation(for lessonID: String) -> Conversation {
        if let conversation = conversationsByLessonID[lessonID] {
            return sanitized(conversation)
        }

        let conversation = Conversation(
            lessonID: lessonID,
            messages: [
                ChatMessage(
                    sender: .assistant,
                    content: "Hi! I can help with this lesson, give hints, or practice one question at a time. What would you like to work on?"
                )
            ]
        )
        conversationsByLessonID[lessonID] = conversation
        persist()
        return conversation
    }

    func save(_ conversation: Conversation) {
        var updatedConversation = sanitized(conversation)
        updatedConversation.updatedDate = Date()
        updatedConversation.messages = compactedMessages(updatedConversation.messages)
        conversationsByLessonID[updatedConversation.lessonID] = updatedConversation
        persist()
    }

    func clearConversation(for lessonID: String) {
        conversationsByLessonID.removeValue(forKey: lessonID)
        persist()
    }

    private func sanitized(_ conversation: Conversation) -> Conversation {
        var conversation = conversation
        conversation.messages = conversation.messages.filter { $0.deliveryState != .failed }
        return conversation
    }

    private func compactedMessages(_ messages: [ChatMessage]) -> [ChatMessage] {
        guard messages.count > 80 else { return messages }
        let greeting = messages.first
        let recentMessages = Array(messages.suffix(60))
        if let greeting, recentMessages.contains(greeting) == false {
            return [greeting] + recentMessages
        }
        return recentMessages
    }

    private func persist() {
        do {
            let data = try encoder.encode(conversationsByLessonID)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            assertionFailure("Failed to persist AI conversations: \(error)")
        }
    }

    private static func loadConversations(
        storageKey: String,
        legacyStorageKey: String,
        decoder: JSONDecoder
    ) -> [String: Conversation] {
        if let conversations = decodeConversations(forKey: storageKey, decoder: decoder) {
            return sanitized(conversations)
        }

        if let conversations = decodeConversations(forKey: legacyStorageKey, decoder: decoder) {
            UserDefaults.standard.removeObject(forKey: legacyStorageKey)
            return sanitized(conversations)
        }

        return [:]
    }

    private static func sanitized(_ conversations: [String: Conversation]) -> [String: Conversation] {
        conversations.mapValues { conversation in
            var conversation = conversation
            conversation.messages = conversation.messages.filter { $0.deliveryState != .failed }
            return conversation
        }
    }

    private static func decodeConversations(forKey key: String, decoder: JSONDecoder) -> [String: Conversation]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? decoder.decode([String: Conversation].self, from: data)
    }
}
