import Foundation

struct PersistedAppState: Codable, Equatable {
    var profile = UserProfile()
    var progress = ProgressData()
    var rewards = RewardData()
    var settings = SettingsData()
}
