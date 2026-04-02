import UIKit

final class EntriesListMetricCell: UICollectionViewCell {
    static let reuseIdentifier = "EntriesListMetricCell"

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    private let statusIndicatorView = UIView()
    private let valueStackView = UIStackView()

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
        valueLabel.text = nil
        unitLabel.text = nil
        statusIndicatorView.backgroundColor = .clear
    }

    func configure(with viewModel: EntriesListMetricCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.todayValueText
        unitLabel.text = viewModel.unitText
        statusIndicatorView.backgroundColor = viewModel.isFilledToday ? .systemGreen : .systemGray3
    }

    private func setupViews() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true // обрезаем все что выходит за рамки

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2 // 2 строки макс или обрез

        valueLabel.font = .systemFont(ofSize: 17, weight: .medium)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .right

        unitLabel.font = .systemFont(ofSize: 13, weight: .regular)
        unitLabel.textColor = .secondaryLabel
        unitLabel.textAlignment = .right

        statusIndicatorView.layer.cornerRadius = 5
        statusIndicatorView.layer.masksToBounds = true

        valueStackView.axis = .vertical
        valueStackView.alignment = .trailing    // == right
        valueStackView.spacing = 4              // спейс между эл-ми

        valueStackView.addArrangedSubview(valueLabel)
        valueStackView.addArrangedSubview(unitLabel)

        contentView.addSubview(statusIndicatorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueStackView)
    }

    private func setupLayout() {
        statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusIndicatorView.widthAnchor.constraint(equalToConstant: 10),
            statusIndicatorView.heightAnchor.constraint(equalToConstant: 10),

            titleLabel.leadingAnchor.constraint(equalTo: statusIndicatorView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            valueStackView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            valueStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
