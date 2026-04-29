import UIKit

final class DSLoadingView: UIView {
    private let stackView = UIStackView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = DS.Spacing.m

        titleLabel.font = DS.Typography.body()
        titleLabel.textColor = DS.Colors.textSecondary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        stackView.addArrangedSubview(activityIndicatorView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    private func setupLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
