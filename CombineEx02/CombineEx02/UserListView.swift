//
//  UserListView.swift
//  CombineEx02
//
//  Created by 윤태한 on 3/31/25.
//
import SwiftUI
import Combine

struct User: Decodable, Identifiable {
    var id: Int
    var name: String
}

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchUsers() {
        guard
            let url =
                URL(string: "https://jsonplaceholder.typicode.com/users")
        else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [User].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$users)
    }
}

struct UserListView: View {
    @StateObject var viewModel = UserViewModel()
    var body: some View {
        List(viewModel.users) { user in
            Text(user.name)
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

