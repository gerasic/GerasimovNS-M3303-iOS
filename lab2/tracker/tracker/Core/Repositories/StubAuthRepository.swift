final class StubAuthRepository: AuthRepository {
    private var savedSession: UserSession?

    func login(request: LoginRequest) async throws -> LoginResponse {
        guard !request.email.isEmpty, !request.password.isEmpty else {
            throw AuthError.invalidCredentials
        }

        return LoginResponse(token: "stub-token", userId: "demo-user")
    }

    func fetchSavedSession() async throws -> UserSession? {
        savedSession
    }

    func saveSession(_ session: UserSession) async throws {
        savedSession = session
    }
}
