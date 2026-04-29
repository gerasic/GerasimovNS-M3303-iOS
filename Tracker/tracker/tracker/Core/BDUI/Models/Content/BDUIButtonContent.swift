import Foundation

struct BDUIButtonContent: Decodable {
    let title: String
    let style: DSButton.Style
    let state: DSButton.State?
}
