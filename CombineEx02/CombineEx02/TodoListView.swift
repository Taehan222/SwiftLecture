//
//  TodoListView.swift
//  CombineEx02
//
//  Created by 윤태한 on 3/31/25.
//

import SwiftUI
import Combine

struct TodoItem: Identifiable {
    var id: UUID = UUID()
    var title: String
    var completed: Bool = false
}

// MARK: - View
struct TodoListView: View {
    @StateObject var viewModel = TodoViewModel()
    @State private var newTitle = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("할 일 추가", text: $newTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("추가") {
                        viewModel.addTodo(title: newTitle)
                        newTitle = ""
                    }
                }.padding()

                List {
                    ForEach(viewModel.todos) { todo in
                        HStack {
                            Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleTodo(todo)
                                }
                            Text(todo.title)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTodo)
                }
            }
            .navigationTitle("📋 Todo List")
            .onAppear {
                viewModel.fetchTodos()
            }
        }
    }
}




//// MARK: - App Entry
//@main
//struct TodoApp: App {
//    var body: some Scene {
//        WindowGroup {
//            TodoListView()
//        }
//    }
//}

#Preview {
    TodoListView()
}
