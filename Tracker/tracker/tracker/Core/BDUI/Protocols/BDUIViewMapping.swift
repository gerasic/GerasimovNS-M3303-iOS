import UIKit

protocol BDUIViewMapping {
    func makeView(from node: BDUIViewNode) -> UIView
}
