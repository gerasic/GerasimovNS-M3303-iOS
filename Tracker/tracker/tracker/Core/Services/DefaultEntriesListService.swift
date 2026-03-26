import Foundation

final class DefaultEntriesListService: EntriesListService {
    private let metricsRepository: MetricsRepository
    private let entriesRepository: EntriesRepository

    init(metricsRepository: MetricsRepository, entriesRepository: EntriesRepository) {
        self.metricsRepository = metricsRepository
        self.entriesRepository = entriesRepository
    }

    func loadSections(userId: UserID) async throws -> [MetricSection] {
        let profile = try await metricsRepository.fetchTrackingProfile(userId: userId)
        return profile.tags.map { tag in
            MetricSection(
                tag: tag,
                metrics: profile.metrics.filter { $0.tagId == tag.id },
                isCollapsed: false
            )
        }
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
