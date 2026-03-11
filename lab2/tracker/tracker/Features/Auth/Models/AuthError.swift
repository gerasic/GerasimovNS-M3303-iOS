enum AuthError: Error, Equatable {
    case invalidCredentials
    case networkUnavailable
    case sessionExpired
}
