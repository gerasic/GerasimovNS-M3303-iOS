import UIKit

final class MetricDetailsViewController: UIViewController, MetricDetailsView {
    private let viewModel: MetricDetailsViewModelInput

    init(viewModel: MetricDetailsViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metric Details"
        view.backgroundColor = .systemBackground
        viewModel.didLoad()
    }

    func render(_ state: MetricDetailsViewState) {
    }
}
