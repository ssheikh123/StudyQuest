import AVFoundation
import SwiftUI

struct LearningAssistantView: View {
    let context: LessonContext?
    let settings: AppAccessibilitySettings

    @State private var conversation = LearningConversation()
    @State private var inputText = ""
    @State private var isSending = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                messages
                suggestedPrompts
                inputBar
            }
            .background(settings.screenBackground)
            .navigationTitle("Learning Assistant")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 72, height: 72)
                .background(settings.accentColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 22))

            VStack(alignment: .leading, spacing: 4) {
                Text("Learning Assistant")
                    .font(.studyQuest(.title3, weight: .bold))
                    .foregroundStyle(settings.primaryText)
                Text(contextText)
                    .font(.studyQuest(.subheadline, weight: .semibold))
                    .foregroundStyle(settings.secondaryText)
            }
            Spacer()
        }
        .padding(16)
        .studyQuestCard(settings: settings)
        .padding(16)
    }

    private var messages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(conversation.messages) { message in
                        HStack(spacing: 8) {
                            LearningMessageBubble(message: message, settings: settings)
                            if settings.textToSpeech && message.role == .assistant {
                                Button {
                                    speak(message.text)
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                }
                                .accessibilityLabel("Speak assistant response")
                            }
                        }
                        .id(message.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .onChange(of: conversation.messages.count) { _, _ in
                if let lastID = conversation.messages.last?.id {
                    withAnimation(settings.reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var suggestedPrompts: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(LearningPromptBuilder.suggestedPrompts, id: \.self) { prompt in
                    Button(prompt) {
                        inputText = prompt
                        send()
                    }
                    .font(.studyQuest(.caption, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(settings.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask for a hint", text: $inputText, axis: .vertical)
                .font(.studyQuest(.body))
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...3)

            Button(action: send) {
                Image(systemName: "paperplane.fill")
                    .font(.headline.weight(.bold))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.borderedProminent)
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
            .accessibilityLabel("Send message")
        }
        .padding(16)
        .background(settings.cardBackground)
    }

    private var contextText: String {
        guard let context else { return "Hints, examples, and practice" }
        return "\(context.subject) • \(context.lessonTitle) • \(context.difficulty.rawValue)"
    }

    private func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        conversation.messages.append(LearningMessage(role: .student, text: text))
        isSending = true
        Task {
            let response = await LearningAssistantManager.response(to: text, conversation: conversation, context: context)
            conversation.messages.append(LearningMessage(role: .assistant, text: response))
            isSending = false
        }
    }

    private func speak(_ text: String) {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            return
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }
}
