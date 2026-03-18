protocol AuthService {
    func login(request: LoginRequest) async throws -> UserSession
    func restoreSession() async throws -> UserSession?
}
