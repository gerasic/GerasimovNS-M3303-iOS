import UIKit

final class DSEmptyView: UIView {
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

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.configure(
            .init(
                typography: .bodyMedium,
                textColor: .textSecondary,
                alignment: .center,
                numberOfLines: 0
            )
        )

        addSubview(titleLabel)
    }

    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
