//
//  NoteListViewController.swift
//  NoteApp
//
//  Created by 윤태한 on 4/1/25.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class NoteListViewController: UIViewController {

    // UITableView를 사용해 노트 목록 표시
    private let tableView = UITableView()

    // 노트 데이터: (문서 ID, 제목, 내용)
    private var notes: [(id: String, title: String, content: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchNotes() // Firestore에서 노트 데이터 가져오기
    }

    // UI 구성: 테이블뷰 및 네비게이션 바에 추가 버튼 설정
    private func setupUI() {
        view.backgroundColor = .white
        title = "내 노트"

        // 테이블뷰 기본 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // 네비게이션 바 우측에 노트 추가 버튼 배치
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNote)
        )
    }

    // Firestore에서 현재 사용자의 노트 데이터 읽어오기 (실시간 동기화)
    private func fetchNotes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users")
            .document(userId)
            .collection("notes")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Firestore 오류: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                self?.notes = documents.map { doc in
                    let data = doc.data()
                    let title = data["title"] as? String ?? "제목 없음"
                    let content = data["content"] as? String ?? "내용 없음"
                    return (id: doc.documentID, title: title, content: content)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
    }

    // MARK: - 노트 추가 기능

    @objc private func addNote() {
        let alert = UIAlertController(title: "새 노트", message: "제목과 내용을 입력하세요.", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "제목" }
        alert.addTextField { $0.placeholder = "내용" }

        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let self = self,
                  let userId = Auth.auth().currentUser?.uid else { return }
            let title = alert.textFields?[0].text ?? "제목 없음"
            let content = alert.textFields?[1].text ?? "내용 없음"

            // Firestore에 새 노트 추가
            Firestore.firestore().collection("users")
                .document(userId)
                .collection("notes")
                .addDocument(data: ["title": title, "content": content]) { error in
                    if let error = error {
                        print("노트 추가 오류: \(error.localizedDescription)")
                    } else {
                        print("노트 추가 완료")
                    }
                }
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return notes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    // 셀 선택 시 노트 수정 화면 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editNote(at: indexPath.row)
    }

    // 스와이프 삭제 기능 구현
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            guard let userId = Auth.auth().currentUser?.uid else { return }

            Firestore.firestore().collection("users")
                .document(userId)
                .collection("notes")
                .document(note.id)
                .delete { error in
                    if let error = error {
                        print("노트 삭제 오류: \(error.localizedDescription)")
                    } else {
                        print("노트 삭제 완료")
                    }
                }
        }
    }

    // 노트 수정 기능: 셀 선택 시 Alert 창 띄워 수정
    private func editNote(at index: Int) {
        let note = notes[index]

        let alert = UIAlertController(title: "노트 수정", message: "제목과 내용을 수정하세요.", preferredStyle: .alert)
        alert.addTextField { $0.text = note.title }
        alert.addTextField { $0.text = note.content }

        let updateAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            guard let self = self,
                  let userId = Auth.auth().currentUser?.uid else { return }
            let newTitle = alert.textFields?[0].text ?? "제목 없음"
            let newContent = alert.textFields?[1].text ?? "내용 없음"

            Firestore.firestore().collection("users")
                .document(userId)
                .collection("notes")
                .document(note.id)
                .updateData(["title": newTitle, "content": newContent]) { error in
                    if let error = error {
                        print("노트 수정 오류: \(error.localizedDescription)")
                    } else {
                        print("노트 수정 완료")
                    }
                }
        }

        alert.addAction(updateAction)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}
