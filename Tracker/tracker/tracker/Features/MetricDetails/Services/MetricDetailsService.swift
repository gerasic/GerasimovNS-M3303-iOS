import Foundation

protocol MetricDetailsService {
    func loadMetricDetails(userId: UserID, metricId: MetricID, range: ChartRange) async throws -> MetricDetailsData
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws
}
