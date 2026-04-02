import Foundation

protocol EntriesListService {
    func loadTrackingProfile(userId: UserID) async throws -> TrackingProfile
    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws
}
