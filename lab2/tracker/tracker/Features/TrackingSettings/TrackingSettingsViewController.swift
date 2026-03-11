import UIKit

final class TrackingSettingsViewController: UIViewController, TrackingSettingsView {
    private let viewModel: TrackingSettingsViewModelInput

    init(viewModel: TrackingSettingsViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tracking Settings"
        view.backgroundColor = .systemBackground
        viewModel.didLoad()
    }

    func render(_ state: TrackingSettingsViewState) {
    }
}
