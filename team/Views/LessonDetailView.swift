import AVFoundation
import SwiftUI

struct LessonDetailView: View {
    let lesson: Lesson
    let isCompleted: Bool
    let nextLesson: Lesson?
    let settings: AppAccessibilitySettings
    let close: () -> Void
    let completeLesson: () -> Void
    let openNextLesson: (Lesson) -> Void

    @State private var selectedAnswerIDs: [String: String] = [:]
    @State private var feedbackText = "Answer every question to finish the lesson."
    @State private var didCompleteLesson = false
    @State private var speechSynthesizer = AVSpeechSynthesizer()

    private var lessonColor: Color {
        lesson.displayColor(colorblindMode: settings.colorblindMode)
    }

    private var hasAnsweredEveryQuestion: Bool {
        lesson.quizQuestions.allSatisfy { selectedAnswerIDs[$0.id] != nil }
    }

    private var canShowCompletion: Bool {
        isCompleted || didCompleteLesson
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    lessonHero

                    LessonContentSection(
                        title: "Lesson Introduction",
                        iconName: "sparkle",
                        text: lesson.introduction,
                        color: lessonColor,
                        settings: settings
                    )

                    LessonContentSection(
                        title: "2-3 Minute Explanation",
                        iconName: "text.book.closed.fill",
                        text: lesson.explanation,
                        color: lessonColor,
                        settings: settings
                    )

                    LessonContentSection(
                        title: "Worked Example",
                        iconName: "pencil.and.outline",
                        text: lesson.workedExample,
                        color: lessonColor,
                        settings: settings
                    )

                    quizSection

                    if canShowCompletion {
                        completionSection
                    }
                }
                .padding(.bottom, 22)
            }
            .background(settings.screenBackground)
            .navigationTitle(lesson.subjectTitle)
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
                    Button(canShowCompletion ? "Done" : "Submit") {
                        submitQuiz()
                    }
                    .disabled(!hasAnsweredEveryQuestion && !canShowCompletion)
                }
            }
        }
    }

    private var lessonHero: some View {
        ZStack(alignment: .bottomLeading) {
            lessonColor
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: lesson.iconName)
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(.white)
                Text(lesson.title)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Text("\(lesson.difficulty.rawValue) • Earn \(lesson.xpReward) XP • \(lesson.badgeProgress)% badge")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(22)
        }
        .frame(height: 230)
    }

    private var quizSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Mini Quiz")
                .font(.title2.weight(.bold))
                .padding(.horizontal, 20)

            ForEach(Array(lesson.quizQuestions.enumerated()), id: \.element.id) { index, question in
                QuizQuestionCard(
                    index: index,
                    question: question,
                    selectedAnswerID: selectedAnswerIDs[question.id],
                    color: lessonColor,
                    settings: settings,
                    selectAnswer: { answerID in
                        selectedAnswerIDs[question.id] = answerID
                    }
                )
                .padding(.horizontal, 20)
            }

            Text(feedbackText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(canShowCompletion ? .green : .secondary)
                .padding(.horizontal, 20)
        }
    }

    private var completionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Lesson Complete", systemImage: "checkmark.seal.fill")
                .font(.title3.weight(.bold))
                .foregroundStyle(.green)

            Text("You earned \(lesson.xpReward) XP and advanced \(lesson.badgeProgress)% toward this subject badge.")
                .font(.body)
                .foregroundStyle(.secondary)

            if let nextLesson {
                Button {
                    openNextLesson(nextLesson)
                } label: {
                    Label("Unlock Next Lesson", systemImage: "arrow.right.circle.fill")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .tint(lessonColor)
            }
        }
        .padding(18)
        .background(settings.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.dashboardCornerRadius))
        .padding(.horizontal, 20)
    }

    private func speakLesson() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            return
        }

        let quizText = lesson.quizQuestions.map(\.prompt).joined(separator: ". ")
        let lessonText = [lesson.title, lesson.introduction, lesson.explanation, lesson.workedExample, quizText].joined(separator: ". ")
        let utterance = AVSpeechUtterance(string: lessonText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(utterance)
    }

    private func submitQuiz() {
        if canShowCompletion {
            close()
            return
        }

        guard hasAnsweredEveryQuestion else { return }

        let isCorrect = lesson.quizQuestions.allSatisfy { question in
            selectedAnswerIDs[question.id] == question.correctAnswerID
        }

        if isCorrect {
            didCompleteLesson = true
            feedbackText = "Correct! XP added and the next lesson is unlocked."
            completeLesson()
        } else {
            feedbackText = "Not quite. Review your answers and try again."
        }
    }
}
