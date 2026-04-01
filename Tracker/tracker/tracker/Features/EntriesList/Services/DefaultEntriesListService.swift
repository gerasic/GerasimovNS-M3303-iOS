import Foundation

final class DefaultEntriesListService: EntriesListService {
    private let metricsRepository: MetricsRepository
    private let entriesRepository: EntriesRepository

    init(metricsRepository: MetricsRepository, entriesRepository: EntriesRepository) {
        self.metricsRepository = metricsRepository
        self.entriesRepository = entriesRepository
    }

    func loadTrackingProfile(userId: UserID) async throws -> TrackingProfile {
        try await metricsRepository.fetchTrackingProfile(userId: userId)
    }

    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws {
        try await entriesRepository.saveMetricValue(
            userId: userId,
            metricId: metricId,
            value: value,
            recordedAt: recordedAt
        )
    }
}
