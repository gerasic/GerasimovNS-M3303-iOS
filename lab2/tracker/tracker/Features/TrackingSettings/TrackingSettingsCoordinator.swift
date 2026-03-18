import UIKit

final class TrackingSettingsCoordinator: Coordinator {
    var onFinish: ((Bool) -> Void)?

    private let navigationController: UINavigationController
    private let userId: UserID
    private let metricsRepository: MetricsRepository

    init(
        navigationController: UINavigationController,
        userId: UserID,
        metricsRepository: MetricsRepository
    ) {
        self.navigationController = navigationController
        self.userId = userId
        self.metricsRepository = metricsRepository
    }

    func start() {
        let service = DefaultTrackingSettingsService(metricsRepository: metricsRepository)
        let viewModel = TrackingSettingsViewModel(userId: userId, service: service)
        let viewController = TrackingSettingsViewController(viewModel: viewModel)

        viewModel.view = viewController
        viewModel.onClose = { [weak self] in
            self?.finish(didSave: false)
        }
        viewModel.onSavedProfile = { [weak self] _ in
            self?.finish(didSave: true)
        }

        let modalNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(modalNavigationController, animated: true)
    }

    private func finish(didSave: Bool) {
        navigationController.presentedViewController?.dismiss(animated: true) { [weak self] in
            self?.onFinish?(didSave)
        }
    }
}
