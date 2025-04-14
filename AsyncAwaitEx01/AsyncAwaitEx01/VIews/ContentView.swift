//
//  ContentView.swift
//  AsyncAwaitEx01
//
//  Created by 윤태한 on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var message = "시작 전"

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.title2)

            Button("Task 실행") {
                Task {
                    await runTask1()
                }
            }

            Button("실패 Task 실행") {
                Task {
                    await runFailingTask()
                }
            }
        }
        .padding()
    }

    func runTask1() async {
        print("1. Task1 시작")
        message = "2. Task1 메세지"

        do {
            let result = try await task1()
            print(">>> fullfilled: \(result.data), \(result.num)")
            message = "성공: \(result.data) - \(result.num)"
        } catch {
            print(">>> rejected: \(error.localizedDescription)")
            message = "에러: \(error.localizedDescription)"
        }
    }

    func task1() async throws -> (data: String, num: Int) {
        var num = 0
        print("3. Task 내부 시작", num)

        try await Task.sleep(nanoseconds: 2000_000_000) // 2초(2000ms)

        num = 1004
        print("4. Task 내부 끝", num)

        return (data: "Task1 결과", num)
    }

    func runFailingTask() async {
        print("1. 실패 Task 시작")
        message = "실패 Task 실행 중.."

        do {
            let result = try await failingTask()
            print(">>> fullfilled: \(result)")
            message = "성공: \(result)"
        } catch {
            print(">>> rejected: \(error.localizedDescription)")
            message = "에러발생: \(error.localizedDescription)"
        }
    }

    func failingTask() async throws -> String {
        try await Task.sleep(nanoseconds: 2000_000_000)
        throw NSError(domain: "TaskError", code: 999, userInfo: [NSLocalizedDescriptionKey: "에러 메시지"])
    }
}

#Preview {
    ContentView()
}
