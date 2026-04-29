import UIKit

extension UIView {
    func bduiView<T: UIView>(withId id: String, as type: T.Type = T.self) -> T? {
        if accessibilityIdentifier == id, let typedSelf = self as? T {
            return typedSelf
        }

        for subview in subviews {
            if let match: T = subview.bduiView(withId: id, as: type) {
                return match
            }
        }

        return nil
    }
}
