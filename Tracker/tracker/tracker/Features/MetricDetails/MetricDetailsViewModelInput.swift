import Foundation

protocol MetricDetailsViewModelInput: AnyObject {
    func didLoad()
    func didTapSaveValue(_ value: Double, recordedAt: Date)
    func didChangeMetricTag(tagId: TagID)
    func didChangeRange(_ range: ChartRange)
    func didTapPoint(entryId: EntryID)
    func didTapBack()
}
