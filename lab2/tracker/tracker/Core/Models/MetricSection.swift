struct MetricSection: Equatable {
    let tag: MetricTag
    let metrics: [TrackedMetric]
    let isCollapsed: Bool
}
