import Foundation

struct MetricPoint: Equatable {
    let recordedAt: Date
    let value: Double
    let entryId: EntryID?
}
