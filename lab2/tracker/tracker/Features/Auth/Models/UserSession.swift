import Foundation

struct UserSession: Equatable {
    let token: String
    let userId: UserID
    let expiresAt: Date
}
