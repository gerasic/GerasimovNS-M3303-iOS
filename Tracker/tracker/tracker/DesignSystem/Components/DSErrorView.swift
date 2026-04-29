import UIKit

final class DSErrorView: UIView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
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

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = DS.Spacing.s

        titleLabel.font = DS.Typography.sectionTitle()
        titleLabel.textColor = DS.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = DS.Typography.body()
        messageLabel.textColor = DS.Colors.textSecondary
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        configureActionButton(title: "Retry")

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)
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
