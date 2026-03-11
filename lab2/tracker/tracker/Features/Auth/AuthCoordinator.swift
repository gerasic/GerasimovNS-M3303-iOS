final class AuthCoordinator: AuthRouter {
    private weak var appCoordinator: AppCoordinator?

    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    func openEntriesList(userId: UserID) {
        appCoordinator?.showEntriesList(userId: userId)
    }
}
