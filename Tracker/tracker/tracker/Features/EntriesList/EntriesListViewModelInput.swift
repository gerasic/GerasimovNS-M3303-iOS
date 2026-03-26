import Foundation

protocol EntriesListViewModelInput: AnyObject {
    func didLoad()
    func didTapEditMetrics()
    func didTapMetric(metricId: MetricID)
    func didTapAddValue(metricId: MetricID, value: Double, recordedAt: Date)
    func didToggleSection(tagId: TagID)
}
