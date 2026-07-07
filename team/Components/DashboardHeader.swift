import SwiftUI

struct DashboardHeader: View {
    let learnerName: String
    let level: Int
    let xp: Int
    let coins: Int
    let avatarColor: AvatarColor
    let avatarAccessory: AvatarAccessory
    let settings: AppAccessibilitySettings
    let notificationAction: () -> Void

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timeOfDay: String

        switch hour {
        case 5..<12:
            timeOfDay = "Morning"
        case 12..<17:
            timeOfDay = "Afternoon"
        default:
            timeOfDay = "Evening"
        }

        return "Good \(timeOfDay), \(learnerName)!"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 14) {
                SparkBadge(size: 54)

                VStack(alignment: .leading, spacing: 6) {
                    Text(greeting)
                        .font(.studyQuest(.title2, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Spark says: Let's learn something awesome today!")
                        .font(.studyQuest(.subheadline, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.86))
                }

                Spacer()

                Button(action: notificationAction) {
                    Image(systemName: "bell.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(.white.opacity(0.18))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Notifications")
            }

            HStack(spacing: 14) {
                AvatarPreview(color: avatarColor.color, accessory: avatarAccessory)
                    .frame(width: 94, height: 94)
                    .background(.white.opacity(settings.darkMode ? 0.08 : 0.15))
                    .clipShape(Circle())
                    .accessibilityLabel("User avatar")

                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        DashboardStatPill(title: "Level", value: "\(level)", iconName: "star.fill")
                        DashboardStatPill(title: "XP", value: "\(xp)", iconName: "bolt.fill")
                    }
                    DashboardStatPill(title: "Coins", value: "\(coins)", iconName: "circle.hexagongrid.fill")
                }
            }
        }
        .padding(22)
        .background(AppTheme.brandGradient(colorblindMode: settings.colorblindMode))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
        .shadow(color: settings.darkMode ? .clear : AppTheme.cardShadow, radius: 20, x: 0, y: 12)
    }
}

private struct DashboardStatPill: View {
    let title: String
    let value: String
    let iconName: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.caption.weight(.bold))
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.studyQuest(.caption2, weight: .bold))
                    .textCase(.uppercase)
                    .opacity(0.78)
                Text(value)
                    .font(.studyQuest(.headline, weight: .bold))
            }
            Spacer(minLength: 0)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.16))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.fieldRadius))
    }
}
