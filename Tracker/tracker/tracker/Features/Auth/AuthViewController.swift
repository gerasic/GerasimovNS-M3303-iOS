import UIKit

final class AuthViewController: UIViewController, AuthView {
    private let viewModel: AuthViewModelInput
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let errorLabel = UILabel()
    private let loginButton = DSButton()

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

        setupViews()
        setupLayout()
        setupActions()
        setupKeyboardObservers()

        viewModel.didLoad()
    }

    func render(_ state: AuthViewState) {
        switch state {
        case .initial:
            setLoading(false)
            errorLabel.isHidden = true
            errorLabel.text = nil
        case let .editing(email, password):
            setLoading(false)
            errorLabel.isHidden = true
            errorLabel.text = nil
            if emailTextField.text != email {
                emailTextField.text = email
            }
            if passwordTextField.text != password {
                passwordTextField.text = password
            }
        case .loading:
            setLoading(true)
            errorLabel.isHidden = true
            errorLabel.text = nil
        case let .error(message):
            setLoading(false)
            errorLabel.isHidden = false
            errorLabel.text = message
        case .content:
            setLoading(false)
            errorLabel.isHidden = true
            errorLabel.text = nil
        }
    }

    private func setupViews() {
        titleLabel.text = "Sign In"
        titleLabel.font = DS.Typography.screenTitle()
        titleLabel.textColor = DS.Colors.textPrimary
        titleLabel.textAlignment = .center

        configureTextField(emailTextField, placeholder: "Email")
        emailTextField.keyboardType = .emailAddress

        configureTextField(passwordTextField, placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        
        errorLabel.textColor = DS.Colors.error
        errorLabel.font = DS.Typography.footnote()
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        configureLoginButton(isLoading: false)

        [
            scrollView,
            contentView,
            titleLabel,
            emailTextField,
            passwordTextField,
            errorLabel,
            loginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false     // отключить автоконстрейнты
        }
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(errorLabel)
        contentView.addSubview(loginButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DS.Spacing.xl),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            emailTextField.heightAnchor.constraint(equalToConstant: DS.Size.textFieldHeight),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: DS.Spacing.m),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            passwordTextField.heightAnchor.constraint(equalToConstant: DS.Size.textFieldHeight),

            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),

            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: DS.Spacing.l),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.l)
        ])
    }

    private func setupActions() {
        emailTextField.addTarget(self, action: #selector(didChangeEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePassword), for: .editingChanged)
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
        viewModel.didChangeEmail(emailTextField.text)
    }

    @objc private func didChangePassword() {
        viewModel.didChangePassword(passwordTextField.text)
    }

    @objc private func didTapLogin() {
        viewModel.didTapLogin(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }

    private func setLoading(_ isLoading: Bool) {
        emailTextField.isEnabled = !isLoading
        passwordTextField.isEnabled = !isLoading
        configureLoginButton(isLoading: isLoading)
    }

    private func configureLoginButton(isLoading: Bool) {
        loginButton.configure(
            DSButton.Configuration(
                title: isLoading ? "Loading..." : "Log In",
                style: .primary,
                state: isLoading ? .loading : .enabled,
                action: { [weak self] in
                    self?.didTapLogin()
                }
            )
        )
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.font = DS.Typography.body()
        textField.textColor = DS.Colors.textPrimary
        textField.backgroundColor = DS.Colors.surface
        textField.layer.cornerRadius = DS.CornerRadius.medium
        textField.layer.borderWidth = 1
        textField.layer.borderColor = DS.Colors.separator.cgColor
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: DS.Spacing.m, height: 1))
        textField.leftViewMode = .always
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
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
