import UIKit

final class DSSeparatorView: UIView {
    private static var defaultThickness: CGFloat {
        let displayScale = UITraitCollection.current.displayScale
        let scale = displayScale > 0 ? displayScale : 1
        return 1 / scale
    }

    struct Configuration {
        let colorToken: DS.ColorToken
        let thickness: CGFloat

        init(
            colorToken: DS.ColorToken = .separator,
            thickness: CGFloat = DSSeparatorView.defaultThickness
        ) {
            self.colorToken = colorToken
            self.thickness = thickness
        }
    }

    private var thicknessConstraint: NSLayoutConstraint?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ configuration: Configuration = .init()) {
        backgroundColor = DS.Colors.value(for: configuration.colorToken)

        if let thicknessConstraint {
            thicknessConstraint.constant = configuration.thickness
            return
        }

        let thicknessConstraint = heightAnchor.constraint(equalToConstant: configuration.thickness)
        thicknessConstraint.isActive = true
        self.thicknessConstraint = thicknessConstraint
    }
}
