import UIKit

final class EntriesListViewController: UIViewController, EntriesListView {
    private let viewModel: EntriesListViewModelInput
    private let collectionView: UICollectionView
    private let collectionManager = EntriesListCollectionManager()
    private let stateActionHandler = DefaultBDUIActionHandler()
    private lazy var mapper: BDUIViewMapping = DefaultBDUIViewMapper(actionHandler: stateActionHandler)

    private lazy var loadingView: UIView = makeStateView(resourceName: "entries_loading_state")
    private lazy var emptyView: UIView = makeStateView(resourceName: "entries_empty_state")
    private lazy var errorView: UIView = makeStateView(resourceName: "entries_error_state")

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
        view.backgroundColor = DS.Colors.background

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
        loadingView.isHidden = true
        emptyView.isHidden = true
        errorView.isHidden = true

        stateActionHandler.onReload = { [weak self] in
            self?.handleRetryTap()
        }

        view.addSubview(loadingView)
        view.addSubview(emptyView)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: DS.Spacing.l),
            loadingView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -DS.Spacing.l),

            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: DS.Spacing.l),
            emptyView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -DS.Spacing.l),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l)
        ])
    }

    private func renderInitialState() {
        collectionView.isHidden = true
        (loadingView as? DSLoadingView)?.stopAnimating()
        loadingView.isHidden = true
        emptyView.isHidden = true
        errorView.isHidden = true
    }

    private func renderLoadingState() {
        collectionView.isHidden = true
        emptyView.isHidden = true
        errorView.isHidden = true
        loadingView.isHidden = false
        (loadingView as? DSLoadingView)?.startAnimating()
    }

    private func renderContentState() {
        collectionView.isHidden = false
        (loadingView as? DSLoadingView)?.stopAnimating()
        loadingView.isHidden = true
        emptyView.isHidden = true
        errorView.isHidden = true
    }

    private func renderEmptyState() {
        collectionView.isHidden = true
        (loadingView as? DSLoadingView)?.stopAnimating()
        loadingView.isHidden = true
        emptyView.isHidden = false
        errorView.isHidden = true
    }

    private func renderErrorState(_ errorViewModel: EntriesListErrorViewModel) {
        collectionView.isHidden = true
        (loadingView as? DSLoadingView)?.stopAnimating()
        loadingView.isHidden = true
        emptyView.isHidden = true
        errorView.isHidden = false

        (errorView as? DSErrorView)?.configure(
            title: errorViewModel.title,
            message: errorViewModel.message,
            actionTitle: errorViewModel.actionTitle
        )
    }

    @objc
    private func handleRetryTap() {
        viewModel.didLoad()
    }

    private static func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(
            top: DS.Spacing.m,
            left: DS.Spacing.m,
            bottom: DS.Spacing.m,
            right: DS.Spacing.m
        )

        return layout
    }

    private func makeStateView(resourceName: String) -> UIView {
        do {
            let node = try BDUIResourceLoader.loadNode(named: resourceName, subdirectory: "BDUI")
            return mapper.makeView(from: node)
        } catch {
            let fallbackLabel = DSLabel()
            fallbackLabel.configure(
                .init(
                    text: error.localizedDescription,
                    typography: .footnote,
                    textColor: .error,
                    alignment: .center,
                    numberOfLines: 0
                )
            )
            return fallbackLabel
        }
    }
}
