import AVFoundation
import SwiftUI

struct LessonDetailView: View {
    let lesson: STEMLesson
    let isCompleted: Bool
    let settings: AppAccessibilitySettings
    let close: () -> Void
    let completeLesson: () -> Void

    @State private var selectedAnswerIndex: Int?
    @State private var feedbackText = "Pick an answer to finish the lesson."
    @State private var didAnswerCorrectly = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .bottomLeading) {
                        lessonColor
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: lesson.iconName)
                                .font(.system(size: 52, weight: .bold))
                                .foregroundStyle(.white)
                            Text(lesson.title)
                                .font(.largeTitle.weight(.bold))
                                .foregroundStyle(.white)
                            Text("Earn \(lesson.xpReward) XP")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(22)
                    }
                    .frame(height: 220)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Mini Lesson")
                            .font(.title3.weight(.bold))

                        ForEach(lesson.facts, id: \.self) { fact in
                            Label(fact, systemImage: "sparkle")
                                .font(.body)
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(lesson.question)
                            .font(.title3.weight(.bold))

                        ForEach(lesson.answers.indices, id: \.self) { index in
                            AnswerButton(
                                title: lesson.answers[index],
                                isSelected: selectedAnswerIndex == index,
                                color: lessonColor,
                                action: { selectedAnswerIndex = index }
                            )
                        }

                        Text(feedbackText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(didAnswerCorrectly ? .green : .secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 22)
                }
            }
            .background(settings.screenBackground)
            .navigationTitle(lesson.category)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: close)
                }
                if settings.textToSpeech {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: speakLesson) {
                            Label("Speak", systemImage: "speaker.wave.2.fill")
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isCompleted || didAnswerCorrectly ? "Done" : "Submit") {
                        submitAnswer()
                    }
                    .disabled(selectedAnswerIndex == nil && !didAnswerCorrectly && !isCompleted)
                }
            }
        }
    }

    private func speakLesson() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            return
        }

        let lessonText = ([lesson.title] + lesson.facts + [lesson.question]).joined(separator: ". ")
        let utterance = AVSpeechUtterance(string: lessonText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    private func submitAnswer() {
        if isCompleted || didAnswerCorrectly {
            close()
            return
        }

        guard let selectedAnswerIndex else { return }

        if selectedAnswerIndex == lesson.correctAnswerIndex {
            didAnswerCorrectly = true
            feedbackText = "Correct! XP added to your profile."
            completeLesson()
        } else {
            feedbackText = "Not quite. Try another answer."
        }
    }
}
