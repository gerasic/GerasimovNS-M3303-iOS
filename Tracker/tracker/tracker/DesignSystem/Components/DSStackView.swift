import UIKit

final class DSStackView: UIStackView {
    struct Configuration {
        let axis: DS.AxisToken
        let spacing: DS.SpacingToken
        let alignment: DS.StackAlignmentToken
        let distribution: DS.StackDistributionToken
        let contentInsets: DS.Insets

        init(
            axis: DS.AxisToken = .vertical,
            spacing: DS.SpacingToken = .none,
            alignment: DS.StackAlignmentToken = .fill,
            distribution: DS.StackDistributionToken = .fill,
            contentInsets: DS.Insets = .init()
        ) {
            self.axis = axis
            self.spacing = spacing
            self.alignment = alignment
            self.distribution = distribution
            self.contentInsets = contentInsets
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init() {
        self.init(frame: .zero)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ configuration: Configuration) {
        axis = DS.Layout.axis(for: configuration.axis)
        spacing = DS.Spacing.value(for: configuration.spacing)
        alignment = DS.Layout.stackAlignment(for: configuration.alignment)
        distribution = DS.Layout.stackDistribution(for: configuration.distribution)
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = DS.Spacing.insets(for: configuration.contentInsets)
    }
}
