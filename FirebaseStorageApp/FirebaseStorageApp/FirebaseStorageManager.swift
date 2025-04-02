//
//  FirebaseStorageManager.swift
//  FirebaseStorageApp
//
//  Created by 윤태한 on 4/2/25.
//


import FirebaseStorage
import UIKit

// Firebase Storage를 사용하여 이미지 업로드를 관리하는 싱글턴 클래스
class FirebaseStorageManager {

    // 싱글턴 패턴을 사용하여 인스턴스 생성 (전역적으로 접근 가능)
    static let shared = FirebaseStorageManager()

    // Firebase Storage의 루트 참조 생성
    private let storageRef = Storage.storage().reference()

    // 이미지 업로드 함수
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {

        // UIImage를 JPEG 데이터로 변환 (압축률: 0.8)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        // 업로드할 이미지의 고유한 파일명을 생성 (UUID 사용)
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")

        // Firebase Storage에 이미지 데이터 업로드
        imageRef.putData(imageData, metadata: nil) { _, error in
            // 업로드 중 오류가 발생하면 실패 처리
            if let error = error {
                completion(.failure(error))
                return
            }

            // 업로드가 성공하면 다운로드 URL을 가져옴
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error)) // 다운로드 URL을 가져오는 중 오류 발생
                } else if let url = url {
                    completion(.success(url.absoluteString)) // 성공적으로 URL 반환
                }
            }
        }
    }
}