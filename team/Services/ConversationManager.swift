import Foundation

final class ConversationManager {
    static let shared = ConversationManager()

    private let storageKey = "studyquest.ai.conversations.v2"
    private let legacyStorageKey = "studyquest.ai.conversations.v1"
    private let maxPersistedMessages = 8
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private var conversationsByLessonID: [String: Conversation]

    private init() {
        conversationsByLessonID = Self.loadConversations(
            storageKey: storageKey,
            legacyStorageKey: legacyStorageKey,
            decoder: decoder,
            maxPersistedMessages: maxPersistedMessages
        )
    }

    func conversation(for lessonID: String) -> Conversation {
        if let conversation = conversationsByLessonID[lessonID] {
            return sanitized(conversation)
        }

        let conversation = Conversation(
            lessonID: lessonID,
            messages: [Self.starterMessage()]
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
        conversation.messages = Self.sanitizedMessages(
            conversation.messages,
            maxPersistedMessages: maxPersistedMessages
        )
        return conversation
    }

    private func compactedMessages(_ messages: [ChatMessage]) -> [ChatMessage] {
        Self.sanitizedMessages(messages, maxPersistedMessages: maxPersistedMessages)
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
        decoder: JSONDecoder,
        maxPersistedMessages: Int
    ) -> [String: Conversation] {
        if let conversations = decodeConversations(forKey: storageKey, decoder: decoder) {
            return sanitized(conversations, maxPersistedMessages: maxPersistedMessages)
        }

        if let conversations = decodeConversations(forKey: legacyStorageKey, decoder: decoder) {
            UserDefaults.standard.removeObject(forKey: legacyStorageKey)
            return sanitized(conversations, maxPersistedMessages: maxPersistedMessages)
        }

        return [:]
    }

    private static func sanitized(
        _ conversations: [String: Conversation],
        maxPersistedMessages: Int
    ) -> [String: Conversation] {
        conversations.mapValues { conversation in
            var conversation = conversation
            conversation.messages = sanitizedMessages(
                conversation.messages,
                maxPersistedMessages: maxPersistedMessages
            )
            return conversation
        }
    }

    private static func sanitizedMessages(
        _ messages: [ChatMessage],
        maxPersistedMessages: Int
    ) -> [ChatMessage] {
        let sentMessages = messages.filter { message in
            message.deliveryState != .failed && message.sender != .system
        }
        guard sentMessages.count > maxPersistedMessages else { return sentMessages }

        let greeting = sentMessages.first { message in
            message.sender == .assistant && message.content == starterMessageContent
        }
        let recentLimit = greeting == nil ? maxPersistedMessages : maxPersistedMessages - 1
        let recentMessages = Array(sentMessages.filter { message in
            greeting?.id != message.id
        }.suffix(recentLimit))

        if let greeting {
            return [greeting] + recentMessages
        }
        return recentMessages
    }

    private static func starterMessage() -> ChatMessage {
        ChatMessage(
            sender: .assistant,
            content: starterMessageContent
        )
    }

    private static var starterMessageContent: String {
        "Hi! I can help with this lesson, give hints, or practice one question at a time. What would you like to work on?"
    }

    private static func decodeConversations(forKey key: String, decoder: JSONDecoder) -> [String: Conversation]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? decoder.decode([String: Conversation].self, from: data)
    }
}
