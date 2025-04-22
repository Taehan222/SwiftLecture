//
//  ContentView.swift
//  AlanTest
//
//  Created by 윤태한 on 4/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var resultText = "Alan에게 질문해보세요."
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 30) {
            Text("Alan API 테스트")
                .font(.title)

            Text(resultText)
                .padding()
                .multilineTextAlignment(.center)

            Button(action: {
                isLoading = true
                AlanService.shared.sendCommand("안녕") { reply in
                    DispatchQueue.main.async {
                        self.resultText = reply ?? "응답 없음"
                        self.isLoading = false
                    }
                }
            }) {
                Text(isLoading ? "질문 중..." : "Alan에게 '안녕' 질문하기")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isLoading)
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
