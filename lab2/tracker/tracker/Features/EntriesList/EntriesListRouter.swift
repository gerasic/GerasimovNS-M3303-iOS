protocol EntriesListRouter: AnyObject {
    func openTrackingSettings(userId: UserID)
    func openMetricDetails(userId: UserID, metricId: MetricID)
}
