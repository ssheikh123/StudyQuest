enum Leveling {
    static func level(for xp: Int) -> Int {
        xp / 100 + 1
    }

    static func progressToNextLevel(for xp: Int) -> Double {
        Double(xp % 100) / 100
    }
}
