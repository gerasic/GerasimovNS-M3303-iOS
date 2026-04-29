import Foundation

struct BDUILabelContent: Decodable {
    let text: String
    let textColor: DS.ColorToken?
    let typography: DS.TypographyToken?
    let alignment: DS.TextAlignmentToken?
    let numberOfLines: Int?
}
