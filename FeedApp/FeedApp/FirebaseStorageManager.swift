//
//  FirebaseStorageManager.swift
//  FeedApp
//
//  Created by 윤태한 on 4/2/25.
//

import FirebaseStorage
import UIKit

// Firebase Storage에서 이미지 업로드 및 삭제를 관리하는 싱글턴 클래스
class FirebaseStorageManager {
    
    // 싱글턴 인스턴스 생성
    static let shared = FirebaseStorageManager()
    
    // Firebase Storage 참조
    private let storageRef = Storage.storage().reference()
    
    // 이미지 업로드 함수
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // UIImage를 JPEG 데이터로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        // 업로드할 이미지의 고유 파일명 생성
        let fileName = UUID().uuidString + ".jpg"
        let imageRef = storageRef.child("images/\(fileName)")
        
        // Firebase Storage에 이미지 업로드
        imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error)) // 오류 발생 시 실패 처리
                return
            }
            
            // 업로드가 완료되면 다운로드 URL 가져오기
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString)) // 업로드된 이미지의 URL 반환
                }
            }
        }
    }
    
    // Firebase Storage에서 이미지 삭제
    func deleteImage(imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // 이미지 경로 추출
        let filePath = imageUrl.components(separatedBy: "/o/").last?.components(separatedBy: "?").first?.removingPercentEncoding
        
        guard let path = filePath else {
            completion(.failure(NSError(domain: "FirebaseStorage", code: -1, userInfo: [NSLocalizedDescriptionKey: "잘못된 파일 경로"])))
            return
        }
        
        let imageRef = storageRef.child(path)
        
        // Firebase Storage에서 이미지 삭제
        imageRef.delete { error in
            if let error = error {
                completion(.failure(error)) // 삭제 실패
            } else {
                completion(.success(())) // 삭제 성공
            }
        }
    }
}
