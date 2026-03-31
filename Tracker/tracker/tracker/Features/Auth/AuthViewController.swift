import UIKit

final class AuthViewController: UIViewController, AuthView {
    private let viewModel: AuthViewModelInput
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let errorLabel = UILabel()
    private let loginButton = UIButton(type: .system)

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
        view.backgroundColor = .systemBackground

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
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        emailTextField.placeholder = "Email"            // серый текст-подсказка внутри
        emailTextField.borderStyle = .roundedRect       
        emailTextField.keyboardType = .emailAddress     // кейборд под имейл 
        emailTextField.autocapitalizationType = .none   // автозаглавные буквы
        emailTextField.autocorrectionType = .no         // т9

        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true      // скрывание букв
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no

        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0                    // = 0 снять огран на колво строк
        errorLabel.isHidden = true

        loginButton.setTitle("Log In", for: .normal)

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
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func setupActions() {
        emailTextField.addTarget(self, action: #selector(didChangeEmail), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangePassword), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
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
        loginButton.isEnabled = !isLoading
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
