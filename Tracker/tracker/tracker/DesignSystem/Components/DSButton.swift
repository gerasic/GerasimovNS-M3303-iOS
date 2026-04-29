import UIKit

final class DSButton: UIButton {
    enum Style: String, Decodable {
        case primary
        case secondary
    }

    enum State: String, Decodable {
        case enabled
        case disabled
        case loading
    }

    struct Configuration {
        let title: String
        let style: Style
        let state: State
        let action: (() -> Void)?
    }

    private var action: (() -> Void)?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ configuration: Configuration) {
        action = configuration.action

        setTitle(configuration.title, for: .normal)
        isEnabled = configuration.state == .enabled
        applyStyle(configuration.style, state: configuration.state)
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = DS.CornerRadius.medium
        titleLabel?.font = DS.Typography.button()
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: DS.Size.buttonHeight)
        ])

        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    private func applyStyle(_ style: Style, state: State) {
        switch style {
        case .primary:
            backgroundColor = state == .enabled ? DS.Colors.primary : DS.Colors.disabled
            layer.borderWidth = 0
            layer.borderColor = nil
            setTitleColor(.white, for: .normal)
            setTitleColor(.white, for: .disabled)
        case .secondary:
            let color = state == .enabled ? DS.Colors.primary : DS.Colors.disabled
            backgroundColor = .clear
            layer.borderWidth = 1
            layer.borderColor = color.cgColor
            setTitleColor(color, for: .normal)
            setTitleColor(color, for: .disabled)
        }
    }

    @objc
    private func handleTap() {
        action?()
    }
}
