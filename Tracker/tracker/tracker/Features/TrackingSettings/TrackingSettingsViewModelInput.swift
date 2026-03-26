protocol TrackingSettingsViewModelInput: AnyObject {
    func didLoad()
    func didTapAddExistingMetric(templateId: MetricID, tagId: TagID)
    func didTapCreateMetric(title: String, unit: String, tagId: TagID)
    func didTapCreateTag(title: String)
    func didChangeMetricTag(metricId: MetricID, tagId: TagID)
    func didTapSave()
    func didTapBack()
}
