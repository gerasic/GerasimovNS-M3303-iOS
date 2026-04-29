import Foundation

struct BDUIAction: Decodable {
    let type: BDUIActionType
    let destination: String?
    let message: String?
    let target: String?
}

enum BDUIActionType: String, Decodable {
    case print
    case route
    case reload
    case submit
}
