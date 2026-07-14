import SwiftUI

enum FeedbackManager {
    static func configure(settings: AppAccessibilitySettings) {
        HapticManager.shared.isEnabled = settings.enableHaptics
        SoundManager.shared.isEnabled = settings.enableSounds
        HapticManager.shared.prepareGenerators()
    }

    static func buttonTap() {
        SoundManager.shared.play(.buttonTap)
        HapticManager.shared.light()
    }

    static func quizCorrect() {
        SoundManager.shared.play(.success)
        HapticManager.shared.success()
    }

    static func quizWrong() {
        SoundManager.shared.play(.error)
        HapticManager.shared.error()
    }

    static func purchase() {
        SoundManager.shared.play(.purchase)
        HapticManager.shared.medium()
    }

    static func equipCosmetic() {
        SoundManager.shared.play(.pop)
        HapticManager.shared.selection()
    }

    static func reward() {
        SoundManager.shared.play(.reward)
        HapticManager.shared.success()
    }

    static func earnCoins() {
        SoundManager.shared.play(.coin)
        HapticManager.shared.light()
    }

    static func gainXP() {
        SoundManager.shared.play(.xp)
        HapticManager.shared.light()
    }

    static func levelUp() {
        SoundManager.shared.play(.levelUp)
        HapticManager.shared.heavy()
        HapticManager.shared.success()
    }

    static func badgeUnlock() {
        SoundManager.shared.play(.badge)
        HapticManager.shared.success()
    }

    static func questComplete() {
        SoundManager.shared.play(.questComplete)
        HapticManager.shared.success()
    }

    static func finishLesson() {
        SoundManager.shared.play(.whoosh)
        HapticManager.shared.success()
    }

    static func unlockLesson() {
        SoundManager.shared.play(.pop)
        HapticManager.shared.selection()
    }
}

extension View {
    func studyQuestButtonFeedback() -> some View {
        simultaneousGesture(
            TapGesture().onEnded {
                FeedbackManager.buttonTap()
            }
        )
    }
}
