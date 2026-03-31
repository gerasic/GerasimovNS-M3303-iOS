import Foundation

enum NetworkError: Error, Equatable {
    case transport
    case invalidResponse
    case httpStatus(Int)
    case decoding
}
