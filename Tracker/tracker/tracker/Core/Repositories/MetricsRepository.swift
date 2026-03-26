protocol MetricsRepository {
    func fetchTrackingProfile(userId: UserID) async throws -> TrackingProfile
    func fetchMetricTemplates() async throws -> [MetricTemplate]
    func saveTrackingProfile(userId: UserID, profile: TrackingProfile) async throws
    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws
}
