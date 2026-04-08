import Foundation

struct MetricValue: Equatable {
    let metricId: MetricID
    let value: Double
    let recordedAt: Date
}
