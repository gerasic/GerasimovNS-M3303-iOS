import UIKit

final class DefaultBDUIActionHandler: BDUIActionHandling {
    var onRoute: ((String) -> Void)?
    var onReload: (() -> Void)?
    var onPrint: ((String) -> Void)?
    var onSubmit: ((String) -> Void)?

    func handle(_ action: BDUIAction) {
        switch action.type {
        case .print:
            let message = action.message ?? "BDUI action triggered"
            if let onPrint {
                onPrint(message)
            } else {
                print(message)
            }
        case .route:
            guard let destination = action.destination else { return }
            onRoute?(destination)
        case .reload:
            onReload?()
        case .submit:
            guard let target = action.target else { return }
            onSubmit?(target)
        }
    }
}
