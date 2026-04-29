import UIKit

final class DefaultBDUIViewMapper: BDUIViewMapping {
    private weak var actionHandler: BDUIActionHandling?

    init(actionHandler: BDUIActionHandling? = nil) {
        self.actionHandler = actionHandler
    }

    func makeView(from node: BDUIViewNode) -> UIView {
        let view = makeBaseView(from: node)
        view.accessibilityIdentifier = node.id
        applyLayout(node.layout, to: view)
        attachSubviews(node.subviews, to: view)
        return view
    }

    private func makeBaseView(from node: BDUIViewNode) -> UIView {
        switch node.type {
        case .view:
            return makeContainerView(content: node.content)
        case .scrollView:
            return makeScrollView()
        case .stackView:
            return makeStackView(content: node.content, layout: node.layout)
        case .label:
            return makeLabel(content: node.content)
        case .button:
            return makeButton(content: node.content, action: node.action)
        case .textField:
            return makeTextField(content: node.content)
        case .loadingView:
            return makeLoadingView(content: node.content)
        case .emptyView:
            return makeEmptyView(content: node.content)
        case .errorView:
            return makeErrorView(content: node.content, action: node.action)
        case .spacer:
            return makeSpacer(content: node.content, layout: node.layout)
        case .separator:
            return makeSeparator(content: node.content)
        }
    }

    private func makeContainerView(content: BDUIContent?) -> UIView {
        let view = DSContainerView()

        if case let .view(configuration)? = content {
            view.configure(
                .init(
                    backgroundColorToken: configuration.backgroundColor ?? .transparent,
                    cornerRadius: configuration.cornerRadius ?? .none
                )
            )
        }

        return view
    }

    private func makeScrollView() -> UIView {
        DSScrollView()
    }

    private func makeStackView(content: BDUIContent?, layout: BDUILayout?) -> UIView {
        let stackView = DSStackView()
        stackView.configure(
            .init(
                axis: layout?.axis ?? .vertical,
                spacing: layout?.spacing ?? .none,
                alignment: layout?.alignment ?? .fill,
                distribution: layout?.distribution ?? .fill,
                contentInsets: layout?.insets ?? .init()
            )
        )

        if case let .stackView(configuration)? = content {
            stackView.backgroundColor = configuration.backgroundColor.map { DS.Colors.value(for: $0) }
            stackView.layer.cornerRadius = DS.CornerRadius.value(for: configuration.cornerRadius ?? .none)
            stackView.clipsToBounds = true
        }

        return stackView
    }

    private func makeLabel(content: BDUIContent?) -> UIView {
        let label = DSLabel()

        if case let .label(configuration)? = content {
            label.configure(
                .init(
                    text: configuration.text,
                    typography: configuration.typography ?? .body,
                    textColor: configuration.textColor ?? .textPrimary,
                    alignment: configuration.alignment ?? .natural,
                    numberOfLines: configuration.numberOfLines ?? 1
                )
            )
        }

        return label
    }

    private func makeButton(content: BDUIContent?, action: BDUIAction?) -> UIView {
        let button = DSButton()

        if case let .button(configuration)? = content {
            button.configure(
                .init(
                    title: configuration.title,
                    style: configuration.style,
                    state: configuration.state ?? .enabled,
                    action: { [weak self] in
                        guard let action else { return }
                        self?.actionHandler?.handle(action)
                    }
                )
            )
        }

        return button
    }

    private func makeTextField(content: BDUIContent?) -> UIView {
        let textField = DSTextField()

        if case let .textField(configuration)? = content {
            textField.configure(
                .init(
                    placeholder: configuration.placeholder,
                    contentType: configuration.contentType,
                    keyboardType: resolveKeyboardType(configuration.keyboardType, contentType: configuration.contentType)
                )
            )
        }

        return textField
    }

    private func makeLoadingView(content: BDUIContent?) -> UIView {
        let loadingView = DSLoadingView()

        if case let .loadingView(configuration)? = content {
            loadingView.configure(title: configuration.title)
            loadingView.startAnimating()
        }

        return loadingView
    }

    private func makeEmptyView(content: BDUIContent?) -> UIView {
        let emptyView = DSEmptyView()

        if case let .emptyView(configuration)? = content {
            emptyView.configure(title: configuration.title)
        }

        return emptyView
    }

    private func makeErrorView(content: BDUIContent?, action: BDUIAction?) -> UIView {
        let errorView = DSErrorView()

        if case let .errorView(configuration)? = content {
            errorView.configure(
                title: configuration.title,
                message: configuration.message,
                actionTitle: configuration.actionTitle
            )
        }

        errorView.onRetry = { [weak self] in
            guard let action else { return }
            self?.actionHandler?.handle(action)
        }

        return errorView
    }

    private func makeSpacer(content: BDUIContent?, layout: BDUILayout?) -> UIView {
        let axis: DSSpacerView.Axis = layout?.axis == .horizontal ? .horizontal : .vertical

        if case let .spacer(configuration)? = content {
            return DSSpacerView(sizeToken: configuration.size, axis: axis)
        }

        return DSSpacerView(sizeToken: .none, axis: axis)
    }

    private func makeSeparator(content: BDUIContent?) -> UIView {
        let separator = DSSeparatorView()

        if case let .separator(configuration)? = content {
            separator.configure(
                .init(
                    colorToken: configuration.color ?? .separator,
                    thickness: configuration.thickness ?? DSSeparatorView.Configuration().thickness
                )
            )
        } else {
            separator.configure()
        }

        return separator
    }

    private func attachSubviews(_ subviews: [BDUIViewNode], to parent: UIView) {
        guard !subviews.isEmpty else { return }

        if let stackView = parent as? UIStackView {
            for subview in subviews.map(makeView(from:)) {
                stackView.addArrangedSubview(subview)
            }
            return
        }

        if let scrollView = parent as? UIScrollView {
            attachToScrollView(subviews, scrollView: scrollView)
            return
        }

        attachToContainer(subviews, container: parent)
    }

    private func attachToScrollView(_ subviews: [BDUIViewNode], scrollView: UIScrollView) {
        let contentView = DSContainerView()
        contentView.configure(.init(backgroundColorToken: .transparent, cornerRadius: .none))
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        attachToContainer(subviews, container: contentView)
    }

    private func attachToContainer(_ subviews: [BDUIViewNode], container: UIView) {
        if subviews.count == 1 {
            let child = makeView(from: subviews[0])
            container.addSubview(child)

            NSLayoutConstraint.activate([
                child.topAnchor.constraint(equalTo: container.topAnchor),
                child.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                child.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                child.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
            return
        }

        let stackView = DSStackView()
        stackView.configure(
            .init(
                axis: .vertical,
                spacing: .none,
                alignment: .fill,
                distribution: .fill
            )
        )

        container.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        for child in subviews.map(makeView(from:)) {
            stackView.addArrangedSubview(child)
        }
    }

    private func applyLayout(_ layout: BDUILayout?, to view: UIView) {
        guard let layout else { return }

        view.isHidden = layout.isHidden ?? false

        if let width = layout.width {
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = layout.height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    private func resolveKeyboardType(
        _ keyboardType: BDUIKeyboardType?,
        contentType: DSTextField.ContentType
    ) -> UIKeyboardType {
        if let keyboardType {
            switch keyboardType {
            case .default:
                return .default
            case .emailAddress:
                return .emailAddress
            case .numberPad:
                return .numberPad
            }
        }

        switch contentType {
        case .plain, .password:
            return .default
        case .email:
            return .emailAddress
        }
    }
}
