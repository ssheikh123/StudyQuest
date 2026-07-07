import SwiftUI

struct QuizQuestionCard: View {
    let index: Int
    let question: QuizQuestion
    let selectedAnswerID: String?
    let color: Color
    let settings: AppAccessibilitySettings
    let selectAnswer: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Question \(index + 1)")
                .font(.studyQuest(.caption, weight: .bold))
                .textCase(.uppercase)
                .foregroundStyle(color)

            Text(question.prompt)
                .font(.studyQuest(.headline, weight: .bold))
                .foregroundStyle(settings.primaryText)

            ForEach(question.answers) { answer in
                AnswerButton(
                    title: answer.title,
                    isSelected: selectedAnswerID == answer.id,
                    color: color,
                    action: { selectAnswer(answer.id) }
                )
            }
        }
        .padding(18)
        .studyQuestCard(settings: settings)
    }
}
