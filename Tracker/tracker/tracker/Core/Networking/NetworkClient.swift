import Foundation

protocol NetworkClient {
    func get<T: Decodable>(_ url: URL) async throws -> T
}
