import Foundation

struct BDUILayout: Decodable {
    let axis: DS.AxisToken?
    let spacing: DS.SpacingToken?
    let alignment: DS.StackAlignmentToken?
    let distribution: DS.StackDistributionToken?
    let insets: DS.Insets?

    let width: CGFloat?
    let height: CGFloat?

    let isHidden: Bool?
}
