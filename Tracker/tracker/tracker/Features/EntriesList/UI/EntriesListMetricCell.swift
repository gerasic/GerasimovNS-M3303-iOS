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
        statusIndicatorView.backgroundColor = viewModel.isFilledToday ? DS.Colors.success : DS.Colors.disabled
    }

    private func setupViews() {
        contentView.backgroundColor = DS.Colors.surface
        contentView.layer.cornerRadius = DS.CornerRadius.large
        contentView.layer.masksToBounds = true

        titleLabel.font = DS.Typography.bodySemibold()
        titleLabel.textColor = DS.Colors.textPrimary
        titleLabel.numberOfLines = 2

        valueLabel.font = DS.Typography.bodyMedium()
        valueLabel.textColor = DS.Colors.textPrimary
        valueLabel.textAlignment = .right

        unitLabel.font = DS.Typography.caption()
        unitLabel.textColor = DS.Colors.textSecondary
        unitLabel.textAlignment = .right

        statusIndicatorView.layer.cornerRadius = DS.Size.statusIndicator / 2
        statusIndicatorView.layer.masksToBounds = true

        valueStackView.axis = .vertical
        valueStackView.alignment = .trailing
        valueStackView.spacing = DS.Spacing.xs

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
            statusIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.m),
            statusIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusIndicatorView.widthAnchor.constraint(equalToConstant: DS.Size.statusIndicator),
            statusIndicatorView.heightAnchor.constraint(equalToConstant: DS.Size.statusIndicator),

            titleLabel.leadingAnchor.constraint(equalTo: statusIndicatorView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.m),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -DS.Spacing.m),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            valueStackView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            valueStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.m),
            valueStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
