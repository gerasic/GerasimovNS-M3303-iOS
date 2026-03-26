import Foundation

final class DefaultAuthService: AuthService {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func login(request: LoginRequest) async throws -> UserSession {
        let response = try await repository.login(request: request)
        let session = UserSession(
            token: response.token,
            userId: response.userId,
            expiresAt: Date().addingTimeInterval(3600)
        )
        try await repository.saveSession(session)
        return session
    }

    func restoreSession() async throws -> UserSession? {
        try await repository.fetchSavedSession()
    }
}
