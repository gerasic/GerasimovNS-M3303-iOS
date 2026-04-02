import UIKit

final class EntriesListViewController: UIViewController, EntriesListView {
    private let viewModel: EntriesListViewModelInput
    private let collectionView: UICollectionView
    private let collectionManager = EntriesListCollectionManager()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    private let errorTitleLabel = UILabel()
    private let errorMessageLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    init(viewModel: EntriesListViewModelInput) {
        self.viewModel = viewModel
        self.collectionView = UICollectionView(
            frame: .zero, // коорд и размер рамки
            collectionViewLayout: EntriesListViewController.makeLayout()
        )
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

        setupCollectionView()
        setupCollectionManager()
        setupStateViews()
        
        viewModel.didLoad()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        })
    }

    func render(_ state: EntriesListViewState) {
        switch state {
        case .initial:
            renderInitialState()
        case .loading:
            renderLoadingState()
        case .empty:
            renderEmptyState()
            collectionManager.setSections([], in: collectionView)
        case let .content(sections):
            renderContentState()
            collectionManager.setSections(sections, in: collectionView)
        case let .error(errorViewModel):
            renderErrorState(errorViewModel)
            collectionManager.setSections([], in: collectionView)
        }
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCollectionManager() {
        collectionManager.attach(to: collectionView)
        collectionManager.onSelectMetric = { [weak self] metricId in
            self?.viewModel.didTapMetric(metricId: metricId)
        }
        collectionManager.onToggleSection = { [weak self] tagId in
            self?.viewModel.didToggleSection(tagId: tagId)
        }
    }

    private func setupStateViews() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        errorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false

        emptyLabel.text = "No metrics yet"
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0    // без ограничений
        emptyLabel.isHidden = true

        errorTitleLabel.textColor = .label
        errorTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        errorTitleLabel.textAlignment = .center
        errorTitleLabel.numberOfLines = 0
        errorTitleLabel.isHidden = true

        errorMessageLabel.textColor = .secondaryLabel
        errorMessageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true

        retryButton.setTitleColor(.systemBlue, for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(handleRetryTap), for: .touchUpInside)

        view.addSubview(activityIndicatorView)
        view.addSubview(emptyLabel)
        view.addSubview(errorTitleLabel)
        view.addSubview(errorMessageLabel)
        view.addSubview(retryButton)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),

            errorTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -28),
            errorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            errorMessageLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 8),
            errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            retryButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func renderInitialState() {
        collectionView.isHidden = true
        activityIndicatorView.stopAnimating()
        emptyLabel.isHidden = true
        errorTitleLabel.isHidden = true
        errorMessageLabel.isHidden = true
        retryButton.isHidden = true
    }

    private func renderLoadingState() {
        collectionView.isHidden = true
        emptyLabel.isHidden = true
        errorTitleLabel.isHidden = true
        errorMessageLabel.isHidden = true
        retryButton.isHidden = true
        activityIndicatorView.startAnimating()
    }

    private func renderContentState() {
        collectionView.isHidden = false
        activityIndicatorView.stopAnimating()
        emptyLabel.isHidden = true
        errorTitleLabel.isHidden = true
        errorMessageLabel.isHidden = true
        retryButton.isHidden = true
    }

    private func renderEmptyState() {
        collectionView.isHidden = true
        activityIndicatorView.stopAnimating()
        emptyLabel.isHidden = false
        errorTitleLabel.isHidden = true
        errorMessageLabel.isHidden = true
        retryButton.isHidden = true
    }

    private func renderErrorState(_ errorViewModel: EntriesListErrorViewModel) {
        collectionView.isHidden = true
        activityIndicatorView.stopAnimating()
        emptyLabel.isHidden = true
        errorTitleLabel.isHidden = false
        errorMessageLabel.isHidden = false
        retryButton.isHidden = false

        errorTitleLabel.text = errorViewModel.title
        errorMessageLabel.text = errorViewModel.message
        retryButton.setTitle(errorViewModel.actionTitle, for: .normal)
    }

    @objc
    private func handleRetryTap() {
        viewModel.didLoad()
    }

    private static func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)    // внутр отступы

        return layout
    }
}
