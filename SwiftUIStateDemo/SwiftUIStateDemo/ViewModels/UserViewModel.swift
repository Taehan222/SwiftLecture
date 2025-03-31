//
//  UserViewModel.swift
//  SwiftUIStateDemo
//
//  Created by 윤태한 on 3/28/25.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published private(set) var users: [UserData] = []
    
    func addUser(name: String) {
        // 이름을 입력 받아서 배열에 새 UserData 객체를 생성해서 추가
        let newUser = UserData(id: UUID(), username: name)
        users.append(newUser)
    }
}
