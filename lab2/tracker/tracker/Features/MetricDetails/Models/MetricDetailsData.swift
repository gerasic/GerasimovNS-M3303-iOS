struct MetricDetailsData: Equatable {
    let metric: TrackedMetric
    let lastValue: Double?
    let points: [MetricPoint]
    let tags: [MetricTag]
}
