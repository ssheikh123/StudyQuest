import Foundation

struct SuggestedPrompt: Identifiable, Hashable {
    let id: String
    let title: String
    let message: String

    init(id: String, title: String, message: String? = nil) {
        self.id = id
        self.title = title
        self.message = message ?? title
    }
}
