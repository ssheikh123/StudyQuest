import SwiftUI

struct LevelUpCelebration: Identifiable, Equatable {
    let id = UUID()
    let previousLevel: Int
    let newLevel: Int
    let coinReward: Int
}

struct LevelUpCelebrationView: View {
    let celebration: LevelUpCelebration
    let settings: AppAccessibilitySettings
    let dismiss: () -> Void

    @State private var animate = false

    var body: some View {
        ZStack {
            Color.black.opacity(settings.darkMode ? 0.58 : 0.42)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(AppTheme.goldReward.opacity(0.20))
                        .frame(width: 148, height: 148)
                        .scaleEffect(animate ? 1.08 : 0.92)

                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 92, weight: .bold))
                        .foregroundStyle(AppTheme.goldReward)
                        .rotationEffect(.degrees(animate ? 8 : -8))
                        .scaleEffect(animate ? 1.0 : 0.86)
                }
                .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text("Level Up")
                        .font(.studyQuest(.largeTitle, weight: .bold))
                        .foregroundStyle(settings.primaryText)
                    Text("Level \(celebration.previousLevel) -> Level \(celebration.newLevel)")
                        .font(.studyQuest(.title3, weight: .bold))
                        .foregroundStyle(AppTheme.primary)
                    Text("+\(celebration.coinReward) coins added to your wallet")
                        .font(.studyQuest(.headline, weight: .semibold))
                        .foregroundStyle(settings.secondaryText)
                }
                .multilineTextAlignment(.center)

                Button(action: dismiss) {
                    Label("Continue", systemImage: "sparkles")
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .background(AppTheme.primaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous))
                }
                .buttonStyle(.plain)
                .studyQuestButtonFeedback()
            }
            .padding(24)
            .frame(maxWidth: 340)
            .studyQuestCard(settings: settings, radius: AppTheme.cardRadius)
            .scaleEffect(animate ? 1 : 0.92)
            .opacity(animate ? 1 : 0)
        }
        .onAppear {
            FeedbackManager.levelUp()
            guard !settings.reduceMotion else {
                animate = true
                return
            }
            withAnimation(.spring(response: 0.45, dampingFraction: 0.72)) {
                animate = true
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Level up from level \(celebration.previousLevel) to level \(celebration.newLevel). \(celebration.coinReward) coins awarded.")
    }
}
