import Foundation

enum Leveling {
    static let baseXPPerLevel = 100
    static let growthRate = 1.14

    static func level(for xp: Int) -> Int {
        var level = 1
        var remainingXP = max(0, xp)

        while remainingXP >= xpRequiredToAdvance(from: level) {
            remainingXP -= xpRequiredToAdvance(from: level)
            level += 1
        }

        return level
    }

    static func xpRequiredToAdvance(from level: Int) -> Int {
        let safeLevel = max(1, level)
        let scaledXP = Double(baseXPPerLevel) * pow(growthRate, Double(safeLevel - 1))
        return max(baseXPPerLevel, Int(scaledXP.rounded()))
    }

    static func totalXPRequired(for level: Int) -> Int {
        guard level > 1 else { return 0 }
        return (1..<level).reduce(0) { total, level in
            total + xpRequiredToAdvance(from: level)
        }
    }

    static func xpIntoCurrentLevel(for xp: Int) -> Int {
        let currentLevel = level(for: xp)
        return max(0, xp - totalXPRequired(for: currentLevel))
    }

    static func xpRequiredForCurrentLevel(for xp: Int) -> Int {
        xpRequiredToAdvance(from: level(for: xp))
    }

    static func xpUntilNextLevel(for xp: Int) -> Int {
        xpRequiredForCurrentLevel(for: xp) - xpIntoCurrentLevel(for: xp)
    }

    static func progressToNextLevel(for xp: Int) -> Double {
        let requiredXP = xpRequiredForCurrentLevel(for: xp)
        guard requiredXP > 0 else { return 0 }
        return Double(xpIntoCurrentLevel(for: xp)) / Double(requiredXP)
    }
}
