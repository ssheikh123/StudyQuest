import Foundation

struct PersistedAppState: Codable, Equatable {
    var profile = UserProfile()
    var progress = ProgressData()
    var rewards = RewardData()
    var settings = SettingsData()
    var community = CommunityData()
    var downloads = DownloadData()

    enum CodingKeys: String, CodingKey {
        case profile
        case progress
        case rewards
        case settings
        case community
        case downloads
    }

    init() { }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profile = try container.decodeIfPresent(UserProfile.self, forKey: .profile) ?? UserProfile()
        progress = try container.decodeIfPresent(ProgressData.self, forKey: .progress) ?? ProgressData()
        rewards = try container.decodeIfPresent(RewardData.self, forKey: .rewards) ?? RewardData()
        settings = try container.decodeIfPresent(SettingsData.self, forKey: .settings) ?? SettingsData()
        community = try container.decodeIfPresent(CommunityData.self, forKey: .community) ?? CommunityData()
        downloads = try container.decodeIfPresent(DownloadData.self, forKey: .downloads) ?? DownloadData()
    }
}
