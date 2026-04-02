final class StubMetricsRepository: MetricsRepository {
    private let defaultTags = [
        MetricTag(id: "body", title: "Тело", isSystem: true),
        MetricTag(id: "health", title: "Здоровье", isSystem: true),
    ]

    func fetchTrackingProfile(userId: UserID) async throws -> TrackingProfile {
        TrackingProfile(tags: defaultTags, metrics: [])
    }

    func fetchMetricTemplates() async throws -> [MetricTemplate] {
        [
            MetricTemplate(id: "weight", title: "Вес", unit: "кг", defaultTagId: "body"),
            MetricTemplate(id: "sleep", title: "Сон", unit: "ч", defaultTagId: "health"),
        ]
    }

    func saveTrackingProfile(userId: UserID, profile: TrackingProfile) async throws {
    }

    func updateMetricTag(userId: UserID, metricId: MetricID, tagId: TagID) async throws {
    }
}
