import UIKit

final class AuthCoordinator: Coordinator {
    var onFinish: ((UserID) -> Void)?

    private let navigationController: UINavigationController
    private let authRepository: AuthRepository

    init(navigationController: UINavigationController, authRepository: AuthRepository) {
        self.navigationController = navigationController
        self.authRepository = authRepository
    }

    func start() {
        let authService = DefaultAuthService(repository: authRepository)
        let viewModel = AuthViewModel(service: authService)
        let viewController = AuthViewController(viewModel: viewModel)

        viewModel.view = viewController
        viewModel.onAuthenticated = { [weak self] userId in
            self?.onFinish?(userId)
        }

        navigationController.setViewControllers([viewController], animated: false)
    }
}
