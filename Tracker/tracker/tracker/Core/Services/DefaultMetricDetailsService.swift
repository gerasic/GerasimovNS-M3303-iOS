import Foundation

final class DefaultMetricDetailsService: MetricDetailsService {
    private let metricsRepository: MetricsRepository
    private let entriesRepository: EntriesRepository

    init(metricsRepository: MetricsRepository, entriesRepository: EntriesRepository) {
        self.metricsRepository = metricsRepository
        self.entriesRepository = entriesRepository
    }

    func loadMetricDetails(userId: UserID, metricId: MetricID, range: ChartRange) async throws -> MetricDetailsData {
        let profile = try await metricsRepository.fetchTrackingProfile(userId: userId)
        guard let metric = profile.metrics.first(where: { $0.id == metricId }) else {
            throw MetricsError.metricNotFound
        }

        let points = try await entriesRepository.fetchMetricSeries(userId: userId, metricId: metricId, range: range)
        return MetricDetailsData(
            metric: metric,
            lastValue: points.last?.value,
            points: points,
            tags: profile.tags
        )
    }

    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws {
        try await entriesRepository.saveMetricValue(
            userId: userId,
            metricId: metricId,
            value: value,
            recordedAt: recordedAt
        )
    }

    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws {
        try await metricsRepository.updateMetricTag(userId: userId, metricId: metricId, tagId: tagId)
    }
}
