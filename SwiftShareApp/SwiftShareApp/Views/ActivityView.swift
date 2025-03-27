//
//  ActivityView.swift
//  SwiftShareApp
//
//  Created by 윤태한 on 3/27/25.
//


import SwiftUI
import UIKit

// UIKit의 UIActivityViewController를 SwiftUI에서 사용하기 위한 래퍼
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]            // 공유할 아이템 (텍스트, 이미지, URL 등)
    let applicationActivities: [UIActivity]? = nil  // 커스텀 공유 동작 (옵션)

    // UIViewController 생성
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    // UIViewController 업데이트 (불필요)
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}