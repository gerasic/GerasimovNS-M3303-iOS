import UIKit

final class DSErrorView: UIView {
    private let stackView = DSStackView()
    private let titleLabel = DSLabel()
    private let messageLabel = DSLabel()
    private let actionButton = DSButton()

    var onRetry: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, message: String, actionTitle: String) {
        titleLabel.text = title
        messageLabel.text = message
        configureActionButton(title: actionTitle)
    }

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        stackView.configure(
            .init(
                axis: .vertical,
                spacing: .s,
                alignment: .fill,
                distribution: .fill
            )
        )

        titleLabel.configure(
            .init(
                typography: .sectionTitle,
                textColor: .textPrimary,
                alignment: .center,
                numberOfLines: 0
            )
        )

        messageLabel.configure(
            .init(
                typography: .body,
                textColor: .textSecondary,
                alignment: .center,
                numberOfLines: 0
            )
        )

        configureActionButton(title: "Retry")

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)
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

    private func configureActionButton(title: String) {
        actionButton.configure(
            DSButton.Configuration(
                title: title,
                style: .secondary,
                state: .enabled,
                action: { [weak self] in
                    self?.onRetry?()
                }
            )
        )
    }
}
