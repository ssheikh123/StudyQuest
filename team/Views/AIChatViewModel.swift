import Combine
import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class AIChatViewModel: ObservableObject {
    @Published private(set) var conversation: Conversation
    @Published var draftMessage = ""
    @Published private(set) var isSending = false
    @Published var errorMessage: String?

    let lessonContext: LessonContext

    private let aiManager: AIManager
    private var lastFailedMessage: String?

    var messages: [ChatMessage] {
        conversation.messages
    }

    var suggestedPrompts: [SuggestedPrompt] {
        aiManager.suggestedPrompts(for: lessonContext)
    }

    var messageCount: Int {
        conversation.messages.count
    }

    var canSend: Bool {
        !draftMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }

    convenience init(lessonContext: LessonContext) {
        self.init(lessonContext: lessonContext, aiManager: AIManager.shared)
    }

    init(lessonContext: LessonContext, aiManager: AIManager) {
        self.lessonContext = lessonContext
        self.aiManager = aiManager
        self.conversation = aiManager.conversation(for: lessonContext)
    }

    func sendDraft() {
        send(draftMessage)
    }

    func sendSuggestedPrompt(_ prompt: SuggestedPrompt) {
        send(prompt.message)
    }

    func retryLastFailedMessage() {
        guard let lastFailedMessage else { return }
        send(lastFailedMessage)
    }

    func copyContent(from message: ChatMessage) {
        #if canImport(UIKit)
        UIPasteboard.general.string = message.content
        #endif
    }

    private func send(_ rawMessage: String) {
        let message = rawMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty, !isSending else { return }

        draftMessage = ""
        errorMessage = nil
        lastFailedMessage = nil

        let studentMessage = ChatMessage(sender: .student, content: message)
        conversation.messages.append(studentMessage)
        conversation.updatedDate = Date()
        aiManager.save(conversation)

        isSending = true
        Task {
            let result = await aiManager.send(message, context: lessonContext, conversation: conversation)
            await MainActor.run {
                isSending = false
                switch result {
                case .success(let response):
                    let assistantMessage = ChatMessage(sender: .assistant, content: response)
                    conversation.messages.append(assistantMessage)
                    conversation.updatedDate = Date()
                    aiManager.save(conversation)
                case .failure(let error):
                    lastFailedMessage = message
                    errorMessage = error.localizedDescription
                    let failedMessage = ChatMessage(
                        sender: .assistant,
                        content: error.localizedDescription,
                        deliveryState: .failed
                    )
                    conversation.messages.append(failedMessage)
                    conversation.updatedDate = Date()
                    aiManager.save(conversation)
                }
            }
        }
    }
}
