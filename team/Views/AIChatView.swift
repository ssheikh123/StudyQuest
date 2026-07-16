import SwiftUI

struct AIChatView: View {
    @StateObject private var viewModel: AIChatViewModel
    let settings: AppAccessibilitySettings

    init(lessonContext: LessonContext, settings: AppAccessibilitySettings) {
        _viewModel = StateObject(wrappedValue: AIChatViewModel(lessonContext: lessonContext))
        self.settings = settings
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                AIChatMessagesView(viewModel: viewModel, settings: settings)
                SuggestedQuestionRow(
                    prompts: viewModel.suggestedPrompts,
                    settings: settings,
                    send: viewModel.sendSuggestedPrompt
                )
                ChatInputBar(
                    text: $viewModel.draftMessage,
                    isSending: viewModel.isSending,
                    settings: settings,
                    send: viewModel.sendDraft
                )
            }
            .background(settings.screenBackground)
            .navigationTitle("AI Tutor")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "graduationcap.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(AppTheme.primaryGradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.lessonContext.lessonTitle)
                    .font(.studyQuest(.headline, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                    .lineLimit(1)
                Text("\(viewModel.lessonContext.subject) • guided hints and practice")
                    .font(.studyQuest(.caption, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(AppTheme.cardBackground(darkMode: settings.darkMode))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("AI tutor for \(viewModel.lessonContext.lessonTitle)")
    }
}

private struct AIChatMessagesView: View {
    @ObservedObject var viewModel: AIChatViewModel
    let settings: AppAccessibilitySettings

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        ChatBubble(
                            message: message,
                            settings: settings,
                            copy: { viewModel.copyContent(from: message) },
                            retry: retryAction(for: message)
                        )
                        .id(message.id.uuidString)
                    }

                    if viewModel.isSending {
                        TypingIndicator(settings: settings)
                            .id("typing-indicator")
                    }
                }
                .padding(16)
            }
            .onChange(of: viewModel.messageCount) { _, _ in
                scrollToBottom(proxy)
            }
            .onChange(of: viewModel.isSending) { _, _ in
                scrollToBottom(proxy)
            }
        }
    }

    private func retryAction(for message: ChatMessage) -> (() -> Void)? {
        guard message.deliveryState == .failed else { return nil }
        return viewModel.retryLastFailedMessage
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        guard let lastID = viewModel.messages.last?.id.uuidString else { return }
        let targetID = viewModel.isSending ? "typing-indicator" : lastID

        if settings.reduceMotion {
            proxy.scrollTo(targetID, anchor: .bottom)
        } else {
            withAnimation(.easeOut(duration: 0.22)) {
                proxy.scrollTo(targetID, anchor: .bottom)
            }
        }
    }
}
