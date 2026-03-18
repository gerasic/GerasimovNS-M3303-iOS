import UIKit

final class MetricDetailsCoordinator: Coordinator {
    var onFinish: ((Bool) -> Void)?

    private let navigationController: UINavigationController
    private let userId: UserID
    private let metricId: MetricID
    private let metricsRepository: MetricsRepository
    private let entriesRepository: EntriesRepository
    private var didUpdateMetric = false

    init(
        navigationController: UINavigationController,
        userId: UserID,
        metricId: MetricID,
        metricsRepository: MetricsRepository,
        entriesRepository: EntriesRepository
    ) {
        self.navigationController = navigationController
        self.userId = userId
        self.metricId = metricId
        self.metricsRepository = metricsRepository
        self.entriesRepository = entriesRepository
    }

    func start() {
        let service = DefaultMetricDetailsService(
            metricsRepository: metricsRepository,
            entriesRepository: entriesRepository
        )
        let viewModel = MetricDetailsViewModel(userId: userId, metricId: metricId, service: service)
        let viewController = MetricDetailsViewController(viewModel: viewModel)

        viewModel.view = viewController
        viewModel.onOpenEntry = { entryId in
            // Entry screen is out of scope for this lab. The flow contract is preserved.
            print("Open entry with id: \(entryId)")
        }
        viewModel.onMetricUpdated = { [weak self] in
            self?.didUpdateMetric = true
        }
        viewModel.onClose = { [weak self] in
            self?.finish()
        }

        navigationController.pushViewController(viewController, animated: true)
    }

    private func finish() {
        navigationController.popViewController(animated: true)
        onFinish?(didUpdateMetric)
    }
}
