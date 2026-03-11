final class DefaultTrackingSettingsService: TrackingSettingsService {
    private let metricsRepository: MetricsRepository

    init(metricsRepository: MetricsRepository) {
        self.metricsRepository = metricsRepository
    }

    func loadProfile(userId: UserID) async throws -> TrackingProfile {
        try await metricsRepository.fetchTrackingProfile(userId: userId)
    }

    func loadMetricTemplates() async throws -> [MetricTemplate] {
        try await metricsRepository.fetchMetricTemplates()
    }

    func saveProfile(userId: UserID, profile: TrackingProfile) async throws {
        try await metricsRepository.saveTrackingProfile(userId: userId, profile: profile)
    }
}
