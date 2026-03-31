import Foundation

protocol EntriesListService {
    func loadSections(userId: UserID) async throws -> [MetricSection]
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
}
