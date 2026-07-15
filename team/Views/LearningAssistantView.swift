import SwiftUI

struct LearningAssistantView: View {
    let context: LessonContext?
    let settings: AppAccessibilitySettings

    var body: some View {
        if let context {
            AIChatView(lessonContext: context, settings: settings)
        } else {
            PlaceholderScreen(
                title: "AI Tutor",
                iconName: "graduationcap.fill",
                message: "Open a lesson first so the tutor can help with that lesson only.",
                settings: settings
            )
        }
    }
}
