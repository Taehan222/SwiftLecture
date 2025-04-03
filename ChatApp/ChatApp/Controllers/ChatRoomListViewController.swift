//
//  ChatRoomListViewController.swift
//  ChatApp
//
//  Created by 윤태한 on 4/3/25.
//


import UIKit
import FirebaseFirestore

class ChatRoomListViewController: UIViewController {
    private let tableView = UITableView()
    private var chatRooms: [(id: String, name: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchChatRooms()
    }

    // MARK: - UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        title = "채팅방 목록"
        
        // 채팅방 생성 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addChatRoomTapped)
        )

        // 테이블뷰 델리게이트 및 데이터소스 연결
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatRoomCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - 채팅방 생성 버튼 눌렀을 때
    @objc private func addChatRoomTapped() {
        let alert = UIAlertController(title: "새 채팅방", message: "채팅방 이름을 입력하세요", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "채팅방 이름" }

        let createAction = UIAlertAction(title: "생성", style: .default) { _ in
            guard let roomName = alert.textFields?.first?.text, !roomName.isEmpty else { return }

            let data: [String: Any] = [
                "name": roomName,
                "createdAt": Date().timeIntervalSince1970
            ]

            Firestore.firestore().collection("chatRooms").addDocument(data: data) { error in
                if let error = error {
                    print("채팅방 생성 실패: \(error.localizedDescription)")
                } else {
                    print("채팅방 생성 완료")
                }
            }
        }

        alert.addAction(createAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Firestore에서 채팅방 목록 가져오기
    private func fetchChatRooms() {
        Firestore.firestore().collection("chatRooms")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Firestore 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                    return
                }
                self.chatRooms = documents.compactMap { doc in
                    let id = doc.documentID
                    let name = doc["name"] as? String ?? "알 수 없는 채팅방"
                    return (id, name)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChatRoomListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatRoom = chatRooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        cell.textLabel?.text = chatRoom.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedRoom = chatRooms[indexPath.row]
        
        // ChatViewController로 전환
        let chatVC = ChatViewController(chatRoomId: selectedRoom.id)
        chatVC.title = selectedRoom.name
        navigationController?.pushViewController(chatVC, animated: true)
    }

}