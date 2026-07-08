enum ProfileManager {
    static func freshState() -> PersistedAppState {
        PersistedAppState()
    }

    static func resetLocalProfile() -> PersistedAppState {
        AppPersistenceService.reset()
        let state = freshState()
        AppPersistenceService.save(state)
        return state
    }
}
