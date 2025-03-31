//
//  UserListView.swift
//  SwiftUIStateDemo
//
//  Created by 윤태한 on 3/28/25.
//

import SwiftUI

struct UserListView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @State private var newName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("이름을 입력하세요", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("이름 추가") {
                    guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.addUser(name: newName)
                    newName = ""
                }
                .padding()
                
                List {
                    ForEach(viewModel.users) { user in
                        Text(user.username)
                    }
                }
            }
            .navigationTitle("사용자 목록")
        }
    }
}

#Preview {
    UserListView()
}
