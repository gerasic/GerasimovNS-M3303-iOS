protocol AuthRepository {
    func login(request: LoginRequest) async throws -> LoginResponse
    func fetchSavedSession() async throws -> UserSession?
    func saveSession(_ session: UserSession) async throws
}
