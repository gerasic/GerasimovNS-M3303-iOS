import UIKit

final class DSContainerView: UIView {
    struct Configuration {
        let backgroundColorToken: DS.ColorToken
        let cornerRadius: DS.CornerRadiusToken
        let borderColorToken: DS.ColorToken?
        let borderWidth: CGFloat
        let clipsToBounds: Bool

        init(
            backgroundColorToken: DS.ColorToken = .transparent,
            cornerRadius: DS.CornerRadiusToken = .none,
            borderColorToken: DS.ColorToken? = nil,
            borderWidth: CGFloat = 0,
            clipsToBounds: Bool = true
        ) {
            self.backgroundColorToken = backgroundColorToken
            self.cornerRadius = cornerRadius
            self.borderColorToken = borderColorToken
            self.borderWidth = borderWidth
            self.clipsToBounds = clipsToBounds
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ configuration: Configuration) {
        backgroundColor = DS.Colors.value(for: configuration.backgroundColorToken)
        layer.cornerRadius = DS.CornerRadius.value(for: configuration.cornerRadius)
        layer.borderWidth = configuration.borderWidth
        layer.borderColor = configuration.borderColorToken.map { DS.Colors.value(for: $0).cgColor }
        clipsToBounds = configuration.clipsToBounds
    }
}
