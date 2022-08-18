//
//  LoginController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit

protocol AuthDelegate: AnyObject {
    func authenticationDidComplete()
}
class LoginController: UIViewController {
    private var label: UILabel = {
        var title = UILabel()
        title.text = "ChatPro"
        title.font = UIFont.boldSystemFont(ofSize: 38)
        title.textColor = .systemBlue
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private var emailTextField: AuthTextField = {
        var textField = AuthTextField(placeholder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()
    private var passwordTextField: AuthTextField = {
        var textField = AuthTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private var loginButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    private var registrationButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Don't have an account?", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isEnabled = true
        return button
    }()
    var viewModel = LoginViewModel()
    weak var delegate: AuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureObservers()
    }
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(label)
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 22
        view.addSubview(stack)
        
        let stackConstraints = [
            stack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            stack.widthAnchor.constraint(equalToConstant: view.frame.width - 70),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        
        view.addSubview(registrationButton)
        registrationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        UserManager.logUserIn(email: email, password: password) { result, error in
            if let error = error {
                print("\(error.localizedDescription) - Failed to log user in")
                return
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    @objc func handleRegistration() {
        let controller = RegistrationController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    func configureObservers() {
        [emailTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
    }
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        loginButton.isEnabled = viewModel.formIsValid
        loginButton.backgroundColor = viewModel.backgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    } 
    
}
extension LoginController: AuthDelegate {
    func authenticationDidComplete() {
        self.delegate?.authenticationDidComplete()
    }
}
