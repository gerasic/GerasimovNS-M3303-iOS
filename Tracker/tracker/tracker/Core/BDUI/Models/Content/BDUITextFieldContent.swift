import Foundation

struct BDUITextFieldContent: Decodable {
    let placeholder: String
    let contentType: DSTextField.ContentType
    let keyboardType: BDUIKeyboardType?
}
