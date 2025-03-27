//
//  ContentView.swift
//  SwiftShareApp
//
//  Created by 윤태한 on 3/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showShare = false
        @State private var sharedImage: UIImage?

        var body: some View {
            VStack(spacing: 30) {
                ReportView()

                Button("리포트 공유하기") {
                    sharedImage = ReportView().snapshot()
                    showShare = true
                }
                .padding()
            }
            .sheet(isPresented: $showShare) {
                if let image = sharedImage {
                    ActivityView(activityItems: [image])
                }
            }
            .padding()
        }
}

#Preview {
    ContentView()
}
