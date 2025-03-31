//
//  TodoViewModel.swift
//  CombineEx02
//
//  Created by 윤태한 on 3/31/25.
//

import SwiftUI
import Combine

// MARK: - Model
struct Todo: Identifiable, Codable {
    var id: Int
    var title: String
    var completed: Bool
}

// MARK: - ViewModel
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://jsonplaceholder.typicode.com/todos"

    // READ
    func fetchTodos() {
        guard let url = URL(string: baseURL + "?_limit=10") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Todo].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$todos)
    }

    // CREATE
    func addTodo(title: String) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let newTodo = Todo(id: Int.random(in: 1000...9999), title: title, completed: false)
        request.httpBody = try? JSONEncoder().encode(newTodo)

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Todo.self, decoder: JSONDecoder())
            .replaceError(with: newTodo) // 테스트용이므로 서버 응답 무시하고 바로 추가
            .receive(on: DispatchQueue.main)
            .sink { [weak self] todo in
                self?.todos.append(todo)
            }
            .store(in: &cancellables)
    }

    // UPDATE
    func toggleTodo(_ todo: Todo) {
        guard let url = URL(string: "\(baseURL)/\(todo.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var updatedTodo = todo
        updatedTodo.completed.toggle()
        request.httpBody = try? JSONEncoder().encode(updatedTodo)

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Todo.self, decoder: JSONDecoder())
            .replaceError(with: updatedTodo)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                if let index = self?.todos.firstIndex(where: { $0.id == updated.id }) {
                    self?.todos[index] = updated
                }
            }
            .store(in: &cancellables)
    }

    // DELETE
    func deleteTodo(at offsets: IndexSet) {
        offsets.forEach { index in
            let todo = todos[index]
            guard let url = URL(string: "\(baseURL)/\(todo.id)") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            URLSession.shared.dataTaskPublisher(for: request)
                .map { _ in } // 응답은 무시
                .replaceError(with: ())
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.todos.remove(atOffsets: offsets)
                }
                .store(in: &cancellables)
        }
    }
}
