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
    @State private var floatSparkles = false

    var body: some View {
        ZStack {
            celebrationBackground
            sparkleField
            celebrationContent
        }
        .ignoresSafeArea()
        .onAppear {
            FeedbackManager.levelUp()
            if settings.reduceMotion {
                animate = true
                floatSparkles = true
            } else {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.70)) {
                    animate = true
                }
                withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                    floatSparkles = true
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Level up from level \(celebration.previousLevel) to level \(celebration.newLevel). \(celebration.coinReward) coins awarded.")
    }

    private var celebrationBackground: some View {
        LinearGradient(
            colors: settings.darkMode
                ? [AppTheme.darkBackground, AppTheme.primary, AppTheme.blueAccent]
                : [AppTheme.primary, AppTheme.purpleAccent, AppTheme.blueAccent],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            RadialGradient(
                colors: [AppTheme.goldReward.opacity(0.45), .clear],
                center: .top,
                startRadius: 40,
                endRadius: 330
            )
        }
    }

    private var sparkleField: some View {
        GeometryReader { proxy in
            let points: [(CGFloat, CGFloat, CGFloat)] = [
                (0.16, 0.14, 22), (0.82, 0.16, 18), (0.28, 0.28, 14),
                (0.72, 0.34, 28), (0.12, 0.55, 16), (0.88, 0.60, 20),
                (0.22, 0.78, 26), (0.76, 0.84, 15), (0.50, 0.10, 12),
                (0.47, 0.90, 18)
            ]

            ForEach(points.indices, id: \.self) { index in
                let point = points[index]
                Image(systemName: index.isMultiple(of: 2) ? "sparkle" : "star.fill")
                    .font(.system(size: point.2, weight: .bold))
                    .foregroundStyle(index.isMultiple(of: 2) ? Color.white.opacity(0.82) : AppTheme.goldReward.opacity(0.88))
                    .position(x: proxy.size.width * point.0, y: proxy.size.height * point.1)
                    .offset(y: floatSparkles ? -10 : 10)
                    .rotationEffect(.degrees(floatSparkles ? 12 : -10))
                    .opacity(animate ? 1 : 0)
                    .animation(settings.reduceMotion ? nil : .easeInOut(duration: 1.2 + Double(index) * 0.08).repeatForever(autoreverses: true), value: floatSparkles)
            }
        }
        .accessibilityHidden(true)
    }

    private var celebrationContent: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 24)

            VStack(spacing: 16) {
                Text("Level Up!")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
                    .scaleEffect(animate ? 1 : 0.82)

                levelMedallion

                HStack(spacing: 12) {
                    LevelNumberBadge(title: "Before", level: celebration.previousLevel, isPrimary: false)
                    Image(systemName: "arrow.right")
                        .font(.title2.weight(.black))
                        .foregroundStyle(.white.opacity(0.86))
                    LevelNumberBadge(title: "Now", level: celebration.newLevel, isPrimary: true)
                }
                .offset(y: animate ? 0 : 20)
                .opacity(animate ? 1 : 0)

                rewardPill
            }
            .padding(.horizontal, 22)

            Spacer(minLength: 18)

            VStack(spacing: 10) {
                Button(action: dismiss) {
                    Label("Return to Home", systemImage: "house.fill")
                        .font(.studyQuest(.headline, weight: .bold))
                        .foregroundStyle(AppTheme.primary)
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonRadius, style: .continuous))
                        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
                }
                .buttonStyle(.plain)
                .studyQuestButtonFeedback()

                Text("+\(celebration.coinReward) coins were added to your wallet")
                    .font(.studyQuest(.caption, weight: .bold))
                    .foregroundStyle(.white.opacity(0.86))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(animate ? 1 : 0)
    }

    private var levelMedallion: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: 210, height: 210)
                .scaleEffect(animate ? 1.05 : 0.78)
            Circle()
                .fill(AppTheme.goldReward.opacity(0.92))
                .frame(width: 156, height: 156)
                .shadow(color: AppTheme.goldReward.opacity(0.45), radius: 28, x: 0, y: 12)
            Image(systemName: "star.circle.fill")
                .font(.system(size: 104, weight: .black))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation(settings.reduceMotion ? nil : .spring(response: 0.9, dampingFraction: 0.78), value: animate)
        }
        .accessibilityHidden(true)
    }

    private var rewardPill: some View {
        HStack(spacing: 10) {
            Image(systemName: "circle.hexagongrid.fill")
                .font(.title3.weight(.black))
            Text("+\(celebration.coinReward) coins")
                .font(.studyQuest(.title3, weight: .black))
        }
        .foregroundStyle(Color(red: 0.22, green: 0.12, blue: 0.02))
        .padding(.horizontal, 20)
        .padding(.vertical, 13)
        .background(AppTheme.goldReward)
        .clipShape(Capsule())
        .shadow(color: AppTheme.goldReward.opacity(0.35), radius: 16, x: 0, y: 10)
        .scaleEffect(animate ? 1 : 0.78)
        .accessibilityLabel("Reward: \(celebration.coinReward) coins")
    }
}

private struct LevelNumberBadge: View {
    let title: String
    let level: Int
    let isPrimary: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.studyQuest(.caption, weight: .bold))
                .textCase(.uppercase)
                .opacity(0.78)
            Text("\(level)")
                .font(.system(size: isPrimary ? 40 : 30, weight: .black, design: .rounded))
        }
        .foregroundStyle(isPrimary ? AppTheme.primary : .white)
        .frame(width: isPrimary ? 112 : 92, height: isPrimary ? 112 : 92)
        .background(isPrimary ? Color.white : Color.white.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(isPrimary ? 0.65 : 0.18), lineWidth: 1.5)
        }
    }
}
