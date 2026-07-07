import SwiftUI

struct LessonContentSection: View {
    let title: String
    let iconName: String
    let text: String
    let color: Color
    let settings: AppAccessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: iconName)
                .font(.studyQuest(.title3, weight: .bold))
                .foregroundStyle(color)

            Text(text)
                .font(.studyQuest(.body))
                .foregroundStyle(settings.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .studyQuestCard(settings: settings)
    }
}
