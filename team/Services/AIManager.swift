import Foundation

final class AIManager {
    static let shared = AIManager()

    private let conversationManager: ConversationManager
    private let serviceResult: Result<OpenAIService, OpenAIServiceError>
    private var contextCache: [String: LessonContext] = [:]

    private init(conversationManager: ConversationManager = .shared) {
        self.conversationManager = conversationManager
        do {
            serviceResult = .success(OpenAIService(configuration: try APIConfiguration.development()))
        } catch let error as OpenAIServiceError {
            serviceResult = .failure(error)
        } catch {
            serviceResult = .failure(.unavailable)
        }
    }

    func conversation(for context: LessonContext) -> Conversation {
        cache(context)
        return conversationManager.conversation(for: context.lessonID)
    }

    func save(_ conversation: Conversation) {
        conversationManager.save(conversation)
    }

    func suggestedPrompts(for context: LessonContext) -> [SuggestedPrompt] {
        PromptBuilder.suggestedPrompts(for: context)
    }

    func send(
        _ message: String,
        context: LessonContext,
        conversation: Conversation
    ) async -> Result<String, OpenAIServiceError> {
        cache(context)

        switch serviceResult {
        case .success(let service):
            do {
                let promptRequest = PromptBuilder.buildPrompt(
                    latestMessage: message,
                    lessonContext: context,
                    conversation: conversation
                )
                let response = try await service.send(request: promptRequest)
                return .success(response)
            } catch let error as OpenAIServiceError {
                return .failure(error)
            } catch {
                return .failure(.unavailable)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    func hint(for question: QuizQuestion, hintIndex: Int, context: LessonContext?) -> String {
        if question.hints.indices.contains(hintIndex) {
            return question.hints[hintIndex]
        }

        switch hintIndex {
        case 0:
            return "Read the question carefully and look for the key idea."
        case 1:
            return "Connect the question to \(context?.lessonTitle ?? "this lesson") before choosing an answer."
        default:
            return "Eliminate one answer that clearly does not fit, then compare the remaining choices."
        }
    }

    private func cache(_ context: LessonContext) {
        contextCache[context.lessonID] = context
    }
}
