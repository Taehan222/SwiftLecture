//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 윤태한 on 4/3/25.
//


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "로그인"

        emailField.placeholder = "이메일"
        emailField.autocapitalizationType = .none // 첫글자 대문자 방지
        passwordField.placeholder = "비밀번호"
        passwordField.isSecureTextEntry = true
        loginButton.setTitle("로그인", for: .normal)

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc private func loginTapped() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("로그인 오류: \(error.localizedDescription)")
                return
            }
            let chatRoomVC = ChatRoomListViewController()
            self.navigationController?.pushViewController(chatRoomVC, animated: true)
        }
    }
}