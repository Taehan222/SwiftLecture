//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 윤태한 on 4/3/25.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    private let tableView = UITableView()
    private var messages: [Message] = []
    private let chatRoomId: String

    private let inputContainer = UIView()
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    // 현재 사용자 ID를 저장할 변수
    private var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }


    init(chatRoomId: String) {
        self.chatRoomId = chatRoomId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMessages()
    }

    // MARK: - 메시지 수신 (Firestore → 수동 파싱)
    private func fetchMessages() {
        Firestore.firestore().collection("chatRooms")
            .document(chatRoomId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Firestore 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                    return
                }

                self.messages = documents.compactMap { doc in
                    let data = doc.data()
                    let text = data["text"] as? String ?? ""
                    let senderId = data["senderId"] as? String ?? ""
                    let senderEmail = data["senderEmail"] as? String ?? "익명"
                    let timestamp = data["timestamp"] as? TimeInterval ?? 0
                    return Message(id: doc.documentID, text: text, senderId: senderId, senderEmail: senderEmail, timestamp: timestamp)
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
    }

    // MARK: - 메시지 전송 (수동 데이터 구성)
    @objc private func sendMessage() {
        guard let user = Auth.auth().currentUser else { return }
        let text = inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { return }

        let data: [String: Any] = [
            "text": text,
            "senderId": user.uid,
            "senderEmail": user.email ?? "익명",
            "timestamp": Date().timeIntervalSince1970
        ]

        Firestore.firestore().collection("chatRooms")
            .document(chatRoomId)
            .collection("messages")
            .addDocument(data: data) { error in
                if let error = error {
                    print("메시지 전송 실패: \(error.localizedDescription)")
                }
            }

        inputField.text = ""
    }

    // MARK: - UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        title = "채팅방"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        view.addSubview(tableView)

        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.backgroundColor = .secondarySystemBackground
        view.addSubview(inputContainer)

        inputField.borderStyle = .roundedRect
        inputField.placeholder = "메시지 입력"
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputField)

        sendButton.setTitle("전송", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(sendButton)

        NSLayoutConstraint.activate([
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 50),

            inputField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 12),
            inputField.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),

            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor)
        ])
    }

    // MARK: - 스크롤 맨 아래로 이동
    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = messages[indexPath.row]

        let isMyMessage = message.senderId == currentUserId

        let displayText = isMyMessage
            ? message.text
            : "\(message.senderEmail): \(message.text)"

        cell.textLabel?.text = displayText
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = isMyMessage ? .right : .left
        cell.textLabel?.textColor = isMyMessage ? .systemBlue : .label
        cell.backgroundColor = isMyMessage ? UIColor.systemGray6 : .white

        return cell
    }
}


