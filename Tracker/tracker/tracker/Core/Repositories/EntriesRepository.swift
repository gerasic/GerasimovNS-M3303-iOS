import Foundation

protocol EntriesRepository {
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
    func fetchMetricSeries(userId: UserID, metricId: MetricID, range: ChartRange) async throws -> [MetricPoint]
}
