protocol AuthViewModelInput: AnyObject {
    func didLoad()
    func didChangeEmail(_ email: String?)
    func didChangePassword(_ password: String?)
    func didTapLogin(email: String?, password: String?)
}
