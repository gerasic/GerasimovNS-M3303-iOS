import UIKit

final class DSLoadingView: UIView {
    private let stackView = DSStackView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let titleLabel = DSLabel()

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

        stackView.configure(
            .init(
                axis: .vertical,
                spacing: .m,
                alignment: .center,
                distribution: .fill
            )
        )

        titleLabel.configure(
            .init(
                typography: .body,
                textColor: .textSecondary,
                alignment: .center,
                numberOfLines: 0
            )
        )

        stackView.addArrangedSubview(activityIndicatorView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
