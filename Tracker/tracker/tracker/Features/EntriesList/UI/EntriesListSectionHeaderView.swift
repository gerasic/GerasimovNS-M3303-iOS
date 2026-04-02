import UIKit

final class EntriesListSectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "EntriesListSectionHeaderView"

    var onTap: (() -> Void)?

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let button = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        chevronImageView.transform = .identity
        onTap = nil
    }

    func configure(with viewModel: EntriesListSectionViewModel) {
        titleLabel.text = viewModel.title
        chevronImageView.transform = viewModel.isCollapsed
            ? CGAffineTransform(rotationAngle: -.pi / 2)
            : .identity
    }

    private func setupViews() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label

        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = .secondaryLabel    // ток для системных иконок 
        chevronImageView.contentMode = .scaleAspectFit  // автомасштаб иконки

        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside) // дефолт тап по кнопке

        addSubview(titleLabel)
        addSubview(chevronImageView)
        addSubview(button)
    }

    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            chevronImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),

            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc
    private func handleTap() {
        onTap?()
    }
}
