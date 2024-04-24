//
//  LoginViewController.swift
//  SleekCare
//
//  Created by Nabeel on 03/03/24.
//

import Foundation
import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    
    // UI Elements
    private let stackView = UIStackView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        // Configure stack view
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
        // Configure email text field
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        stackView.addArrangedSubview(emailTextField)
        
        // Configure password text field
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        stackView.addArrangedSubview(passwordTextField)
        
        // Configure login button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        stackView.addArrangedSubview(loginButton)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewWidth = view.isiPad ? 400 : view.bounds.width - 60
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: stackViewWidth),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func handleLogin() {
           guard let email = emailTextField.text, !email.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty else {
               print("Missing field data")
               return
           }
           
           // Firebase login
           Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
               if let error = error {
                   print("Login error: \(error.localizedDescription)")
                   // Handle error by showing alert to the user
               } else {
                   // Navigate to your main app screen
                   print("login success")
                   
               }
           }
       }
}

// Helper extension to detect if the device is an iPad
extension UIView {
    var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
