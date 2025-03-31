//
//  FormView.swift
//  CombineEx0331
//
//  Created by 윤태한 on 3/31/25.
//

import SwiftUI
import Combine

class FormViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return !email.isEmpty && !password.isEmpty >= 6
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
}

struct FormView: View {
    @StateObject var viewModel = FormViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FormView()
}
