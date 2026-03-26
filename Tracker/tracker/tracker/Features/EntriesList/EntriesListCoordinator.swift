import UIKit

final class EntriesListCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let userId: UserID
    private let metricsRepository: MetricsRepository
    private let entriesRepository: EntriesRepository

    private var childCoordinators: [Coordinator] = []
    private weak var entriesListViewModel: EntriesListViewModel?

    init(
        navigationController: UINavigationController,
        userId: UserID,
        metricsRepository: MetricsRepository,
        entriesRepository: EntriesRepository
    ) {
        self.navigationController = navigationController
        self.userId = userId
        self.metricsRepository = metricsRepository
        self.entriesRepository = entriesRepository
    }

    func start() {
        let entriesService = DefaultEntriesListService(
            metricsRepository: metricsRepository,
            entriesRepository: entriesRepository
        )
        let viewModel = EntriesListViewModel(userId: userId, service: entriesService)
        let viewController = EntriesListViewController(viewModel: viewModel)

        viewModel.view = viewController
        viewModel.onOpenTrackingSettings = { [weak self] userId in
            self?.showTrackingSettings(userId: userId)
        }
        viewModel.onOpenMetricDetails = { [weak self] userId, metricId in
            self?.showMetricDetails(userId: userId, metricId: metricId)
        }

        entriesListViewModel = viewModel
        navigationController.setViewControllers([viewController], animated: true)
    }

    private func showTrackingSettings(userId: UserID) {
        let coordinator = TrackingSettingsCoordinator(
            navigationController: navigationController,
            userId: userId,
            metricsRepository: metricsRepository
        )
        coordinator.onFinish = { [weak self, weak coordinator] didSave in
            guard let self else { return }
            if let coordinator {
                self.removeChild(coordinator)
            }
            if didSave {
                self.entriesListViewModel?.didLoad()
            }
        }

        addChild(coordinator)
        coordinator.start()
    }

    private func showMetricDetails(userId: UserID, metricId: MetricID) {
        let coordinator = MetricDetailsCoordinator(
            navigationController: navigationController,
            userId: userId,
            metricId: metricId,
            metricsRepository: metricsRepository,
            entriesRepository: entriesRepository
        )
        coordinator.onFinish = { [weak self, weak coordinator] didUpdateMetric in
            guard let self else { return }
            if let coordinator {
                self.removeChild(coordinator)
            }
            if didUpdateMetric {
                self.entriesListViewModel?.didLoad()
            }
        }

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
