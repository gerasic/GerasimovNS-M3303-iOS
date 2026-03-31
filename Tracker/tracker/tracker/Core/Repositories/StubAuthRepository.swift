final class StubAuthRepository: AuthRepository {
    private let validEmail = "gerasic"
    private let validPassword = "1234"
    private var savedSession: UserSession?

    func login(request: LoginRequest) async throws -> LoginResponse {
        guard request.email == validEmail, request.password == validPassword else {
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
