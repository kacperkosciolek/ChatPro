//
//  RegistrationController.swift
//  ChatPro
//
//  Created by Kacper on 25/04/2022.
//

import UIKit

class RegistrationController: UIViewController {
    
    private var plushPhotoButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        return button
    }()
    private var usernameTextField: AuthTextField = {
        var textField = AuthTextField(placeholder: "Username")
        return textField
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
    private var registrationButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 0.7), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isEnabled = true
        return button
    }()
    private var loginButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Already have an account?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    private var viewModel = RegistrationViewModel()
    var profileImage: UIImage?
    var pickerController = UIImagePickerController()
    weak var delegate: AuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        confgiureObservers()
    }
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plushPhotoButton)
        
        let plushButtonConstraints = [
            plushPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            plushPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plushPhotoButton.heightAnchor.constraint(equalToConstant: 150),
            plushPhotoButton.widthAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(plushButtonConstraints)
        
        let stack = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, registrationButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 28
        view.addSubview(stack)
        
        let stackConstraints = [
            stack.widthAnchor.constraint(equalToConstant: view.frame.width - 70),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: plushPhotoButton.bottomAnchor, constant: 35),
            registrationButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(stackConstraints)
        
        view.addSubview(loginButton)
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func confgiureObservers() {
        [usernameTextField, emailTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
    }
    @objc func uploadImage() {
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    @objc func textDidChange(sender: UITextField) {
        switch sender {
        case usernameTextField:
            viewModel.username = sender.text
        case emailTextField:
            viewModel.email = sender.text
        default:
            viewModel.password = sender.text
        }
        registrationButton.isEnabled = viewModel.formIsValid
        registrationButton.backgroundColor = viewModel.backgroundColor
        registrationButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
    @objc func handleRegistration() {
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let profileImage = self.profileImage else { return }

        UserManager.registerUser(username: username, email: email, password: password, profileImage: profileImage) { err, ref in
            self.delegate?.authenticationDidComplete()
        }
    }
    @objc func handleLogin() {
        let controller = LoginController()
        navigationController?.pushViewController(controller, animated: true)
    }
   
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
}
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileImage = image
        
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width / 2
        
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
}
