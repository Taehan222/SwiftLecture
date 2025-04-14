//
//  AsyncBasicView.swift
//  AsyncAwaitEx01
//
//  Created by 윤태한 on 4/14/25.
//

import SwiftUI

struct AsyncBasicView: View {
    @State private var todoTitle: String = "Todo List"

    var body: some View {
        VStack(spacing: 20) {
            Text(todoTitle)
                .font(.title2)
                .padding()

            
            Button("fetch todo") {
                Task {
                    do {
                        
                        let todo = try await fetchTodo()
                        todoTitle = "\(todo.title) (완료: \(todo.completed))"
                    } catch {
                        
                        todoTitle = "에러 발생: \(error.localizedDescription)"
                    }
                }
            }
        }
        .padding()
    }

    func fetchTodo() async throws -> Todo {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(Todo.self, from: data)
    }
}

#Preview {
    AsyncBasicView()
}
