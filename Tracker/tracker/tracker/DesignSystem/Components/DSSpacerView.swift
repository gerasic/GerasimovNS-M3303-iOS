import UIKit

final class DSSpacerView: UIView {
    enum Axis {
        case horizontal
        case vertical
    }

    private var sizeConstraint: NSLayoutConstraint?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    convenience init(sizeToken: DS.SpacingToken, axis: Axis = .vertical) {
        self.init(frame: .zero)
        configure(sizeToken: sizeToken, axis: axis)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(sizeToken: DS.SpacingToken, axis: Axis = .vertical) {
        let value = DS.Spacing.value(for: sizeToken)

        if let sizeConstraint {
            sizeConstraint.isActive = false
        }

        sizeConstraint = {
            switch axis {
            case .horizontal:
                return widthAnchor.constraint(equalToConstant: value)
            case .vertical:
                return heightAnchor.constraint(equalToConstant: value)
            }
        }()

        sizeConstraint?.isActive = true
    }
}
