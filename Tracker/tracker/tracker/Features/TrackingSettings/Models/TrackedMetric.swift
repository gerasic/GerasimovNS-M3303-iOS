struct TrackedMetric: Equatable {
    let id: MetricID
    let title: String
    let unit: String
    let tagId: TagID
    let currentValue: Double?
}
