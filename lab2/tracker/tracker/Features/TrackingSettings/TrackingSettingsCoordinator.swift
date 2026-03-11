final class TrackingSettingsCoordinator: TrackingSettingsRouter {
    private weak var appCoordinator: AppCoordinator?

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func closeWithSavedProfile(_ profile: TrackingProfile) {
        appCoordinator?.closePresentedScreen()
    }

    func close() {
        appCoordinator?.closePresentedScreen()
    }
}
