import Foundation
@testable import tracker

final class MockEntriesListService: EntriesListService {
    var profile: TrackingProfile = .empty
    var error: Error?

    func loadTrackingProfile(userId: UserID) async throws -> TrackingProfile {
        if let error {
            throw error
        }

        return profile
    }

    func saveMetricValue(userId: UserID, metricId: MetricID, value: Double, recordedAt: Date) async throws {
    }
}
