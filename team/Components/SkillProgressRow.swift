import SwiftUI

struct SkillProgressRow: View {
    let title: String
    let value: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(color)
            }

            ProgressBar(value: value, tint: color)
                .frame(height: 14)
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }
}
