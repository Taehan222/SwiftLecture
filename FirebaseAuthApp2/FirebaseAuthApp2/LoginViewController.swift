//
//  LoginViewController.swift
//  FirebaseAuthApp2
//
//  Created by 윤태한 on 4/1/25.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    // 이메일 입력을 위한 UITextField
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일 입력"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()

    // 비밀번호 입력을 위한 UITextField (보안 입력 설정)
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 입력"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    // 로그인 버튼
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "로그인"
        
        // 디버깅을 위한 로그 추가
        print("LoginViewController - viewDidLoad 실행됨")
        
        setupUI()
    }

    
    private func setupUI() {
        // StackView를 사용하여 이메일, 비밀번호 텍스트필드와 버튼을 수직으로 배치
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        // StackView의 오토레이아웃 제약조건 설정
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])

        // 로그인 버튼의 액션 연결
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

    
    @objc private func handleLogin() {
        // 이메일과 비밀번호가 모두 입력되었는지 확인
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "이메일과 비밀번호를 모두 입력하세요.")
            return
        }

        // Firebase Authentication의 signIn 메서드를 사용하여 로그인 시도
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                // 로그인 실패 시 경고창 표시
                self?.showAlert(message: "로그인 오류: \(error.localizedDescription)")
                return
            }
            // 로그인 성공 시 HomeViewController로 이동
            let homeVC = HomeViewController()
            self?.navigationController?.pushViewController(homeVC, animated: true)
        }
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
