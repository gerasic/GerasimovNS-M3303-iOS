final class EntriesListCoordinator: EntriesListRouter {
    private weak var appCoordinator: AppCoordinator?

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func openTrackingSettings(userId: UserID) {
        appCoordinator?.showTrackingSettings(userId: userId)
    }

    func openMetricDetails(userId: UserID, metricId: MetricID) {
        appCoordinator?.showMetricDetails(userId: userId, metricId: metricId)
    }
}
