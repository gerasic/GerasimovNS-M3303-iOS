import UIKit

final class AuthViewController: UIViewController, AuthView {
    private enum ViewID {
        static let emailField = "auth_email_field"
        static let passwordField = "auth_password_field"
        static let errorLabel = "auth_error_label"
        static let loginButton = "auth_login_button"
    }

    private let viewModel: AuthViewModelInput
    private let actionHandler = DefaultBDUIActionHandler()
    private lazy var mapper: BDUIViewMapping = DefaultBDUIViewMapper(actionHandler: actionHandler)

    private weak var renderedRootView: UIView?
    private weak var scrollView: UIScrollView?
    private weak var emailTextField: DSTextField?
    private weak var passwordTextField: DSTextField?
    private weak var errorLabel: DSLabel?
    private weak var loginButton: DSButton?

    init(viewModel: AuthViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = DS.Colors.background

        setupBDUIScreen()
        setupKeyboardObservers()

        viewModel.didLoad()
    }

    func render(_ state: AuthViewState) {
        switch state {
        case .initial:
            setLoading(false)
            errorLabel?.isHidden = true
            errorLabel?.text = nil
        case let .editing(email, password):
            setLoading(false)
            errorLabel?.isHidden = true
            errorLabel?.text = nil

            if emailTextField?.text != email {
                emailTextField?.text = email
            }

            if passwordTextField?.text != password {
                passwordTextField?.text = password
            }
        case .loading:
            setLoading(true)
            errorLabel?.isHidden = true
            errorLabel?.text = nil
        case let .error(message):
            setLoading(false)
            errorLabel?.isHidden = false
            errorLabel?.text = message
        case .content:
            setLoading(false)
            errorLabel?.isHidden = true
            errorLabel?.text = nil
        }
    }

    private func setupBDUIScreen() {
        actionHandler.onSubmit = { [weak self] target in
            guard target == "login" else { return }
            self?.didTapLogin()
        }

        do {
            let node = try BDUIResourceLoader.loadNode(named: "auth_screen", subdirectory: "BDUI")
            let renderedView = mapper.makeView(from: node)
            renderedRootView = renderedView
            scrollView = renderedView as? UIScrollView

            view.addSubview(renderedView)

            NSLayoutConstraint.activate([
                renderedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                renderedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                renderedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                renderedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            bindRenderedViews()
            configureLoginButton(isLoading: false)
        } catch {
            let fallbackLabel = DSLabel()
            fallbackLabel.configure(
                .init(
                    text: error.localizedDescription,
                    typography: .footnote,
                    textColor: .error,
                    alignment: .center,
                    numberOfLines: 0
                )
            )

            view.addSubview(fallbackLabel)

            NSLayoutConstraint.activate([
                fallbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                fallbackLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                fallbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.l),
                fallbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.l)
            ])
        }
    }

    private func bindRenderedViews() {
        guard let renderedRootView else { return }

        emailTextField = renderedRootView.bduiView(withId: ViewID.emailField)
        passwordTextField = renderedRootView.bduiView(withId: ViewID.passwordField)
        errorLabel = renderedRootView.bduiView(withId: ViewID.errorLabel)
        loginButton = renderedRootView.bduiView(withId: ViewID.loginButton)

        emailTextField?.addTarget(self, action: #selector(didChangeEmail), for: .editingChanged)
        passwordTextField?.addTarget(self, action: #selector(didChangePassword), for: .editingChanged)
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func didChangeEmail() {
        viewModel.didChangeEmail(emailTextField?.text)
    }

    @objc private func didChangePassword() {
        viewModel.didChangePassword(passwordTextField?.text)
    }

    @objc private func didTapLogin() {
        viewModel.didTapLogin(
            email: emailTextField?.text,
            password: passwordTextField?.text
        )
    }

    private func setLoading(_ isLoading: Bool) {
        emailTextField?.isEnabled = !isLoading
        passwordTextField?.isEnabled = !isLoading
        configureLoginButton(isLoading: isLoading)
    }

    private func configureLoginButton(isLoading: Bool) {
        loginButton?.configure(
            .init(
                title: isLoading ? "Loading..." : "Log In",
                style: .primary,
                state: isLoading ? .loading : .enabled,
                action: { [weak self] in
                    self?.actionHandler.handle(
                        BDUIAction(
                            type: .submit,
                            destination: nil,
                            message: nil,
                            target: "login"
                        )
                    )
                }
            )
        )
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let scrollView,
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }

        let keyboardFrameInView = view.convert(endFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardFrameInView)

        scrollView.contentInset.bottom = intersection.height
        scrollView.verticalScrollIndicatorInsets.bottom = intersection.height
    }
}
