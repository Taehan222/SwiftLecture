//
//  LoginViewController.swift
//  NoteApp
//
//  Created by 윤태한 on 4/1/25.
//


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    // UI 요소 정의
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "이메일"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        return field
    }()

    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "비밀번호"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        return field
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // UI 구성 및 오토레이아웃 설정
    private func setupUI() {
        view.backgroundColor = .white
        title = "로그인"

        // 스택뷰 활용하여 요소 배치
        let stackView = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])

        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    // 로그인 버튼 액션
    @objc private func loginTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(message: "이메일과 비밀번호를 모두 입력하세요.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showAlert(message: "로그인 오류: \(error.localizedDescription)")
                return
            }
            // 로그인 성공 후 노트 목록 화면으로 전환
            let noteListVC = NoteListViewController()
            self?.navigationController?.pushViewController(noteListVC, animated: true)
        }
    }

    // 간단한 알림창 표시 함수
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
