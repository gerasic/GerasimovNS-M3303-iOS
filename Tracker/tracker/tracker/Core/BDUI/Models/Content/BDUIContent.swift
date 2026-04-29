import Foundation

enum BDUIContent {
    case view(BDUIContainerContent)
    case scrollView(BDUIScrollViewContent)
    case stackView(BDUIStackViewContent)
    case label(BDUILabelContent)
    case button(BDUIButtonContent)
    case textField(BDUITextFieldContent)
    case loadingView(BDUILoadingViewContent)
    case emptyView(BDUIEmptyViewContent)
    case errorView(BDUIErrorViewContent)
    case spacer(BDUISpacerContent)
    case separator(BDUISeparatorContent)
}
