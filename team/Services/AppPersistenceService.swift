import Foundation

enum AppPersistenceService {
    private static let appStateKey = "studyquest.persistedAppState.v1"

    static func load() -> PersistedAppState {
        guard let data = UserDefaults.standard.data(forKey: appStateKey) else {
            return PersistedAppState()
        }

        do {
            return try JSONDecoder().decode(PersistedAppState.self, from: data)
        } catch {
            return PersistedAppState()
        }
    }

    static func save(_ state: PersistedAppState) {
        do {
            let data = try JSONEncoder().encode(state)
            UserDefaults.standard.set(data, forKey: appStateKey)
        } catch {
            assertionFailure("Failed to persist StudyQuest state: \(error)")
        }
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: appStateKey)
    }
}
