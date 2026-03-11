import UIKit

final class AuthViewController: UIViewController, AuthView {
    private let viewModel: AuthViewModelInput

    init(viewModel: AuthViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Auth"
        view.backgroundColor = .systemBackground
        viewModel.didLoad()
    }

    func render(_ state: AuthViewState) {
    }
}
