import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()

    private let authRepository = StubAuthRepository()
    private let metricsRepository = StubMetricsRepository()
    private let entriesRepository = StubEntriesRepository()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showAuth()
    }

    func showAuth() {
        let authService = DefaultAuthService(repository: authRepository)
        let coordinator = AuthCoordinator(appCoordinator: self)
        let viewModel = AuthViewModel(service: authService, router: coordinator)
        let viewController = AuthViewController(viewModel: viewModel)

        viewModel.view = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showEntriesList(userId: UserID) {
        let entriesService = DefaultEntriesListService(
            metricsRepository: metricsRepository,
            entriesRepository: entriesRepository
        )
        let coordinator = EntriesListCoordinator(appCoordinator: self)
        let viewModel = EntriesListViewModel(userId: userId, service: entriesService, router: coordinator)
        let viewController = EntriesListViewController(viewModel: viewModel)

        viewModel.view = viewController
        navigationController.setViewControllers([viewController], animated: true)
    }

    func showTrackingSettings(userId: UserID) {
        let service = DefaultTrackingSettingsService(metricsRepository: metricsRepository)
        let coordinator = TrackingSettingsCoordinator(appCoordinator: self)
        let viewModel = TrackingSettingsViewModel(userId: userId, service: service, router: coordinator)
        let viewController = TrackingSettingsViewController(viewModel: viewModel)

        viewModel.view = viewController
        let modalNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(modalNavigationController, animated: true)
    }

    func showMetricDetails(userId: UserID, metricId: MetricID) {
        let service = DefaultMetricDetailsService(
            metricsRepository: metricsRepository,
            entriesRepository: entriesRepository
        )
        let coordinator = MetricDetailsCoordinator(appCoordinator: self)
        let viewModel = MetricDetailsViewModel(
            userId: userId,
            metricId: metricId,
            service: service,
            router: coordinator
        )
        let viewController = MetricDetailsViewController(viewModel: viewModel)

        viewModel.view = viewController
        navigationController.pushViewController(viewController, animated: true)
    }

    func closePresentedScreen() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }

    func closeDetailsScreen() {
        navigationController.popViewController(animated: true)
    }

    func openEntry(entryId: EntryID) {
        // Entry screen is out of scope for this lab. The navigation contract exists.
        print("Open entry with id: \(entryId)")
    }
}
