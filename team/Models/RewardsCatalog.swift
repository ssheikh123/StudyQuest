import SwiftUI

enum RewardsCatalog {
    static let dailyRewardCoins = 25
    static let lessonCompletionCoins = 10
    static let levelUpCoins = 50

    static let shopItems: [ShopItem] = [
        ShopItem(id: "hat-graduation", title: "Scholar Cap", category: .hats, iconName: "graduationcap.fill", cost: 80, color: AppTheme.primary),
        ShopItem(id: "hat-star", title: "Star Crown", category: .hats, iconName: "star.fill", cost: 120, color: AppTheme.goldReward),
        ShopItem(id: "glasses-goggles", title: "Lab Goggles", category: .glasses, iconName: "eyeglasses", cost: 60, color: .black, avatarAccessory: .goggles),
        ShopItem(id: "accessory-stars", title: "Starter Stars", category: .accessories, iconName: "sparkles", cost: 0, color: AppTheme.goldReward, avatarAccessory: .stars),
        ShopItem(id: "accessory-bolt", title: "Bolt Badge", category: .accessories, iconName: "bolt.fill", cost: 100, color: .orange, avatarAccessory: .bolt),
        ShopItem(id: "accessory-rocket", title: "Rocket Charm", category: .accessories, iconName: "paperplane.fill", cost: 110, color: .red, avatarAccessory: .rocket),
        ShopItem(id: "wings-bolt", title: "Bolt Wings", category: .wings, iconName: "bolt.fill", cost: 100, color: .orange, avatarAccessory: .bolt),
        ShopItem(id: "wings-rocket", title: "Rocket Wings", category: .wings, iconName: "paperplane.fill", cost: 110, color: .red, avatarAccessory: .rocket),
        ShopItem(id: "background-sky", title: "Sky Lab", category: .backgrounds, iconName: "cloud.sun.fill", cost: 75, color: AvatarColor.sky.color),
        ShopItem(id: "background-gold", title: "Gold Glow", category: .backgrounds, iconName: "sun.max.fill", cost: 95, color: AvatarColor.gold.color),
        ShopItem(id: "color-sky", title: "Starter Sky", category: .colors, iconName: "paintpalette.fill", cost: 0, color: AvatarColor.sky.color, avatarColor: .sky),
        ShopItem(id: "color-mint", title: "Mint Scale", category: .colors, iconName: "paintpalette.fill", cost: 50, color: AvatarColor.mint.color, avatarColor: .mint),
        ShopItem(id: "color-coral", title: "Coral Scale", category: .colors, iconName: "paintpalette.fill", cost: 50, color: AvatarColor.coral.color, avatarColor: .coral),
        ShopItem(id: "color-violet", title: "Violet Scale", category: .colors, iconName: "paintpalette.fill", cost: 70, color: AvatarColor.violet.color, avatarColor: .violet),
        ShopItem(id: "color-gold", title: "Gold Scale", category: .colors, iconName: "paintpalette.fill", cost: 90, color: AvatarColor.gold.color, avatarColor: .gold),
        ShopItem(id: "color-navy", title: "Navy Scale", category: .colors, iconName: "paintpalette.fill", cost: 90, color: AvatarColor.navy.color, avatarColor: .navy)
    ]

    static var avatarCosmeticItems: [ShopItem] {
        shopItems
    }

    static let futureRewards: [FutureReward] = [
        FutureReward(id: "amazon", title: "Amazon Gift Card", levelRequirement: 10, iconName: "cart.fill", color: AppTheme.goldReward),
        FutureReward(id: "target", title: "Target Gift Card", levelRequirement: 12, iconName: "target", color: AppTheme.coral),
        FutureReward(id: "steam", title: "Steam Gift Card", levelRequirement: 14, iconName: "gamecontroller.fill", color: AppTheme.purpleAccent),
        FutureReward(id: "apple", title: "Apple Gift Card", levelRequirement: 16, iconName: "apple.logo", color: AppTheme.primary)
    ]

    static func badges(progress: LessonProgress, xp: Int, level: Int, streak: StreakData, unlockedBadgeIDs: Set<String> = []) -> [RewardBadge] {
        let completed = progress.completedLessonIDs
        return [
            RewardBadge(id: "first-lesson", title: "First Lesson", subtitle: "Complete any lesson", iconName: "flag.checkered", color: AppTheme.greenSuccess, isUnlocked: !completed.isEmpty),
            RewardBadge(id: "level-five", title: "Level 5", subtitle: "Reach Level 5", iconName: "star.fill", color: AppTheme.goldReward, isUnlocked: level >= 5),
            RewardBadge(id: "level-ten", title: "Level 10", subtitle: "Reach Level 10", iconName: "sparkles", color: AppTheme.purpleAccent, isUnlocked: level >= 10),
            RewardBadge(id: "week-streak", title: "Week Streak", subtitle: "Study for 7 days", iconName: "flame.fill", color: AppTheme.coral, isUnlocked: streak.longestStreak >= 7),
            RewardBadge(id: "two-week-streak", title: "Two Week Streak", subtitle: "Study for 14 days", iconName: "flame.circle.fill", color: AppTheme.coral, isUnlocked: unlockedBadgeIDs.contains("two-week-streak") || streak.longestStreak >= 14),
            RewardBadge(id: "math-explorer", title: "Math Explorer", subtitle: "Finish Algebra Beginner", iconName: "x.squareroot", color: AppTheme.primary, isUnlocked: isSubjectComplete("algebra", progress: progress)),
            RewardBadge(id: "reading-champion", title: "Reading Champion", subtitle: "Finish Reading Beginner", iconName: "book.fill", color: .orange, isUnlocked: isSubjectComplete("reading", progress: progress)),
            RewardBadge(id: "science-star", title: "Science Star", subtitle: "Finish Biology Beginner", iconName: "leaf.fill", color: AppTheme.greenSuccess, isUnlocked: isSubjectComplete("biology", progress: progress)),
            RewardBadge(id: "programming-beginner", title: "Programming Beginner", subtitle: "Finish Programming Beginner", iconName: "curlybraces", color: AppTheme.purpleAccent, isUnlocked: isSubjectComplete("programming-fundamentals", progress: progress)),
            RewardBadge(id: "perfect-quiz", title: "Perfect Quiz", subtitle: "Coming soon", iconName: "checkmark.seal.fill", color: AppTheme.goldReward, isUnlocked: false),
            RewardBadge(id: "xp-1000", title: "1000 XP", subtitle: "Earn 1000 XP", iconName: "bolt.fill", color: AppTheme.goldReward, isUnlocked: xp >= 1000)
        ]
    }

    private static func isSubjectComplete(_ subjectID: String, progress: LessonProgress) -> Bool {
        guard let subject = CurriculumData.subjects.first(where: { $0.id == subjectID }) else { return false }
        return progress.completionPercentage(in: subject, difficulty: .beginner) >= 1
    }
}
