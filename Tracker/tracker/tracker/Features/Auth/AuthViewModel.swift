@MainActor
final class AuthViewModel: AuthViewModelInput {
    weak var view: AuthView? {
        didSet {
            renderCurrentState()
        }
    }
    var onAuthenticated: ((UserID) -> Void)?
    private(set) var state: AuthViewState = .initial {
        didSet {
            renderCurrentState()
        }
    }

    private let service: AuthService
    private var email = ""
    private var password = ""

    init(service: AuthService) {
        self.service = service
    }

    func didLoad() {
        Task {
            if let session = try? await service.restoreSession() {
                state = .content(session: session)
                onAuthenticated?(session.userId)
            } else {
                state = .initial
            }
        }
    }

    func didChangeEmail(_ email: String) {
        self.email = email
        state = .editing(email: self.email, password: password)
    }

    func didChangePassword(_ password: String) {
        self.password = password
        state = .editing(email: email, password: self.password)
    }

    func didTapLogin(email: String, password: String) {
        self.email = email
        self.password = password
        state = .loading

        Task {
            do {
                let session = try await service.login(request: LoginRequest(email: email, password: password))
                state = .content(session: session)
                onAuthenticated?(session.userId)
            } catch AuthError.invalidCredentials {
                state = .error(message: "Invalid login or password.")
            } catch {
                state = .error(message: "Something went wrong. Please try again.")
            }
        }
    }

    private func renderCurrentState() {
        view?.render(state)
    }
}
