struct TrackingProfile: Equatable {
    let tags: [MetricTag]
    let metrics: [TrackedMetric]

    static let empty = TrackingProfile(tags: [], metrics: [])
}
