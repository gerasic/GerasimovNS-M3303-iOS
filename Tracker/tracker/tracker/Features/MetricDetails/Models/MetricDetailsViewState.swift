enum MetricDetailsViewState: Equatable {
    case initial
    case loading
    case saving
    case empty
    case content(metric: TrackedMetric, lastValue: Double?, points: [MetricPoint], range: ChartRange, tags: [MetricTag])
    case error(message: String)
}
