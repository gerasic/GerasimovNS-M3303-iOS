import UIKit

final class DSLabel: UILabel {
    struct Configuration {
        let text: String?
        let typography: DS.TypographyToken
        let textColor: DS.ColorToken
        let alignment: DS.TextAlignmentToken
        let numberOfLines: Int

        init(
            text: String? = nil,
            typography: DS.TypographyToken = .body,
            textColor: DS.ColorToken = .textPrimary,
            alignment: DS.TextAlignmentToken = .natural,
            numberOfLines: Int = 1
        ) {
            self.text = text
            self.typography = typography
            self.textColor = textColor
            self.alignment = alignment
            self.numberOfLines = numberOfLines
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
        text = configuration.text
        font = DS.Typography.value(for: configuration.typography)
        textColor = DS.Colors.value(for: configuration.textColor)
        textAlignment = DS.Layout.textAlignment(for: configuration.alignment)
        numberOfLines = configuration.numberOfLines
    }
}
