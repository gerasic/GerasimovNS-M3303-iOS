enum AuthViewState: Equatable {
    case initial
    case editing(email: String, password: String)
    case loading
    case content(session: UserSession)
    case error(message: String)
}
