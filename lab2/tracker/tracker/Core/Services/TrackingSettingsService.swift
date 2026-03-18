protocol TrackingSettingsService {
    func loadProfile(userId: UserID) async throws -> TrackingProfile
    func loadMetricTemplates() async throws -> [MetricTemplate]
    func saveProfile(userId: UserID, profile: TrackingProfile) async throws
}
