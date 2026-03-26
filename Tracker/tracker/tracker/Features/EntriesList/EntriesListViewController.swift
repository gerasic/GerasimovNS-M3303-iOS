import UIKit

final class EntriesListViewController: UIViewController, EntriesListView {
    private let viewModel: EntriesListViewModelInput

    init(viewModel: EntriesListViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metrics"
        view.backgroundColor = .systemBackground
        viewModel.didLoad()
    }

    func render(_ state: EntriesListViewState) {
    }
}
