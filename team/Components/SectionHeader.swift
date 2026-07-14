import SwiftUI

struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.studyQuest(.title3, weight: .bold))
                if let subtitle {
                    Text(subtitle)
                        .font(.studyQuest(.subheadline, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.studyQuest(.subheadline, weight: .bold))
                    .studyQuestButtonFeedback()
            }
        }
    }
}
