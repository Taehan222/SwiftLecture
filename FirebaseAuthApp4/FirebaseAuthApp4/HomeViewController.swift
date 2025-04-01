//
//  HomeViewController.swift
//  FirebaseAuthApp4
//
//  Created by 윤태한 on 4/1/25.
//


import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    // MARK: - UI 요소 정의

    // 환영 메시지를 표시하는 UILabel
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "환영합니다!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    // 로그아웃 버튼
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "홈"
        setupUI()
    }

    // MARK: - UI 구성 및 레이아웃 설정
    private func setupUI() {
        // StackView를 사용하여 환영 메시지와 로그아웃 버튼을 수직으로 배치
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, logoutButton])
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        // StackView의 오토레이아웃 제약조건 설정
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])

        // 로그아웃 버튼의 액션 연결
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }

    // MARK: - 로그아웃 기능 구현
    @objc private func handleLogout() {
        do {
            // Firebase의 signOut()을 호출하여 로그아웃 처리
            try Auth.auth().signOut()
            // 로그인 화면으로 되돌아가기 (네비게이션 스택에서 pop)
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            // 로그아웃 실패 시 경고창 표시
            showAlert(message: "로그아웃 오류: \(signOutError.localizedDescription)")
        }
    }

    // MARK: - 경고창 표시 함수
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}