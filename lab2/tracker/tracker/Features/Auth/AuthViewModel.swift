@MainActor
final class AuthViewModel: AuthViewModelInput {
    weak var view: AuthView?

    private let service: AuthService
    private let router: AuthRouter
    private var email = ""
    private var password = ""

    init(service: AuthService, router: AuthRouter) {
        self.service = service
        self.router = router
    }

    func didLoad() {
        Task {
            if let session = try? await service.restoreSession() {
                view?.render(.content(session: session))
                router.openEntriesList(userId: session.userId)
            } else {
                view?.render(.initial)
            }
        }
    }

    func didChangeEmail(_ email: String) {
        self.email = email
        view?.render(.editing(email: self.email, password: password))
    }

    func didChangePassword(_ password: String) {
        self.password = password
        view?.render(.editing(email: email, password: self.password))
    }

    func didTapLogin(email: String, password: String) {
        view?.render(.loading)

        Task {
            do {
                let session = try await service.login(request: LoginRequest(email: email, password: password))
                view?.render(.content(session: session))
                router.openEntriesList(userId: session.userId)
            } catch {
                view?.render(.error(message: "Не удалось выполнить вход"))
            }
        }
    }
}
