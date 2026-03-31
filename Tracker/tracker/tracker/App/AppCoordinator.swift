import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()

    private let authRepository = StubAuthRepository()
    private let networkClient = URLSessionNetworkClient()
    private lazy var metricsRepository: MetricsRepository = RemoteMetricsRepository(networkClient: networkClient)
    private let entriesRepository = StubEntriesRepository()
    private var childCoordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startAuthFlow()
    }

    private func startAuthFlow() {
        let coordinator = AuthCoordinator(
            navigationController: navigationController,
            authRepository: authRepository
        )
        coordinator.onFinish = { [weak self, weak coordinator] userId in
            guard let self else { return }
            if let coordinator {
                self.removeChild(coordinator)
            }
            self.startMainFlow(userId: userId)
        }

        addChild(coordinator)
        coordinator.start()
    }

    private func startMainFlow(userId: UserID) {
        let coordinator = EntriesListCoordinator(
            navigationController: navigationController,
            userId: userId,
            metricsRepository: metricsRepository,
            entriesRepository: entriesRepository
        )
        addChild(coordinator)
        coordinator.start()
    }

    private func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    private func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
