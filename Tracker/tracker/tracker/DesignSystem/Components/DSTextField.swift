import UIKit

final class DSTextField: UITextField {
    enum ContentType: String, Decodable {
        case plain
        case email
        case password
    }

    struct Configuration {
        let placeholder: String
        let contentType: ContentType
        let keyboardType: UIKeyboardType
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ configuration: Configuration) {
        placeholder = configuration.placeholder
        keyboardType = configuration.keyboardType

        switch configuration.contentType {
        case .plain:
            isSecureTextEntry = false
            textContentType = nil
        case .email:
            isSecureTextEntry = false
            textContentType = .emailAddress
        case .password:
            isSecureTextEntry = true
            textContentType = .password
        }
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        font = DS.Typography.body()
        textColor = DS.Colors.textPrimary
        backgroundColor = DS.Colors.surface
        layer.cornerRadius = DS.CornerRadius.medium
        layer.borderWidth = 1
        layer.borderColor = DS.Colors.separator.cgColor
        autocapitalizationType = .none
        autocorrectionType = .no
        clearButtonMode = .whileEditing
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 1))
        leftViewMode = .always

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: DS.Size.textFieldHeight)
        ])
    }
}
