final class MetricDetailsCoordinator: MetricDetailsRouter {
    private weak var appCoordinator: AppCoordinator?

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func openEntry(entryId: EntryID) {
        appCoordinator?.openEntry(entryId: entryId)
    }

    func close() {
        appCoordinator?.closeDetailsScreen()
    }
}
