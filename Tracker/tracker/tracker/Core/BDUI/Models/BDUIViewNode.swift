import Foundation

struct BDUIViewNode: Decodable {
    let id: String?
    let type: BDUIViewType
    let content: BDUIContent?
    let layout: BDUILayout?
    let subviews: [BDUIViewNode]
    let action: BDUIAction?

    init(
        id: String? = nil,
        type: BDUIViewType,
        content: BDUIContent? = nil,
        layout: BDUILayout? = nil,
        subviews: [BDUIViewNode] = [],
        action: BDUIAction? = nil
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.layout = layout
        self.subviews = subviews
        self.action = action
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case content
        case layout
        case subviews
        case action
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decode(BDUIViewType.self, forKey: .type)
        layout = try container.decodeIfPresent(BDUILayout.self, forKey: .layout)
        subviews = try container.decodeIfPresent([BDUIViewNode].self, forKey: .subviews) ?? []
        action = try container.decodeIfPresent(BDUIAction.self, forKey: .action)
        content = try Self.decodeContent(for: type, from: container)
    }

    private static func decodeContent(
        for type: BDUIViewType,
        from container: KeyedDecodingContainer<CodingKeys>
    ) throws -> BDUIContent? {
        switch type {
        case .view:
            return try container.decodeIfPresent(BDUIContainerContent.self, forKey: .content).map(BDUIContent.view)
        case .scrollView:
            return try container.decodeIfPresent(BDUIScrollViewContent.self, forKey: .content).map(BDUIContent.scrollView)
        case .stackView:
            return try container.decodeIfPresent(BDUIStackViewContent.self, forKey: .content).map(BDUIContent.stackView)
        case .label:
            return try container.decodeIfPresent(BDUILabelContent.self, forKey: .content).map(BDUIContent.label)
        case .button:
            return try container.decodeIfPresent(BDUIButtonContent.self, forKey: .content).map(BDUIContent.button)
        case .textField:
            return try container.decodeIfPresent(BDUITextFieldContent.self, forKey: .content).map(BDUIContent.textField)
        case .loadingView:
            return try container.decodeIfPresent(BDUILoadingViewContent.self, forKey: .content).map(BDUIContent.loadingView)
        case .emptyView:
            return try container.decodeIfPresent(BDUIEmptyViewContent.self, forKey: .content).map(BDUIContent.emptyView)
        case .errorView:
            return try container.decodeIfPresent(BDUIErrorViewContent.self, forKey: .content).map(BDUIContent.errorView)
        case .spacer:
            return try container.decodeIfPresent(BDUISpacerContent.self, forKey: .content).map(BDUIContent.spacer)
        case .separator:
            return try container.decodeIfPresent(BDUISeparatorContent.self, forKey: .content).map(BDUIContent.separator)
        }
    }
}
