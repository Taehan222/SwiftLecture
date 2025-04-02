//
//  ViewController.swift
//  FirebaseStorageApp
//
//  Created by 윤태한 on 4/2/25.
//

import UIKit

// UIImagePickerControllerDelegate, UINavigationControllerDelegate를 채택하여 이미지 선택 기능을 구현
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 이미지가 표시될 UIImageView 생성
    private let imageView = UIImageView()
    
    // 사용자가 이미지를 선택할 수 있는 버튼 생성
    private let selectButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI 구성 설정 함수 호출
        setupUI()
    }

    // UI를 설정하는 함수
    private func setupUI() {
        // 배경색을 흰색으로 설정
        view.backgroundColor = .white
        
        // 네비게이션 타이틀 설정
        title = "이미지 업로드"

        // 이미지 뷰 설정
        imageView.contentMode = .scaleAspectFit // 이미지 비율 유지하며 화면에 맞게 조정
        imageView.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 활성화
        view.addSubview(imageView) // 이미지 뷰를 화면에 추가

        // 버튼 설정
        selectButton.setTitle("이미지 선택", for: .normal) // 버튼 텍스트 설정, 이벤트 핸들러 함수 지정.
        selectButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 활성화
        view.addSubview(selectButton) // 버튼을 화면에 추가
        view.addSubview(uploadButton)

        // Auto Layout 제약 조건 설정
        NSLayoutConstraint.activate([
            // 이미지 뷰를 수평 가운데 정렬
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 화면 상단에서 50pt 아래에 위치
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            // 이미지 뷰 너비 300 설정
            imageView.widthAnchor.constraint(equalToConstant: 300),
            // 이미지 뷰 높이 300 설정
            imageView.heightAnchor.constraint(equalToConstant: 300),

            // 버튼을 수평 가운데 정렬
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 버튼을 이미지 뷰 아래 20pt에 위치
            selectButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 20)
        ])
    }

    // 사용자가 "이미지 선택" 버튼을 클릭하면 실행되는 함수
    @objc private func selectImage() {
        // 이미지 선택 컨트롤러 생성
        let picker = UIImagePickerController()
        // 현재 뷰 컨트롤러를 델리게이트로 지정
        picker.delegate = self
        // 사진 라이브러리에서 이미지 선택하도록 설정
        picker.sourceType = .photoLibrary
        // 이미지 선택 창을 화면에 표시
        present(picker, animated: true, completion: nil)
    }

    // 사용자가 이미지를 선택하면 실행되는 델리게이트 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 선택한 이미지가 존재하면
        if let selectedImage = info[.originalImage] as? UIImage {
            // 이미지 뷰에 선택한 이미지 설정
            imageView.image = selectedImage
        }
        // 이미지 선택 창 닫기
        dismiss(animated: true, completion: nil)
    }
    
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("업로드", for: .normal)
        button.addTarget(ViewController.self, action: #selector(uploadImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc private func uploadImage() {
        guard let image = imageView.image else { return }

        FirebaseStorageManager.shared.uploadImage(image) { result in
            switch result {
            case .success(let url):
                print("이미지 업로드 성공: \(url)")
            case .failure(let error):
                print("이미지 업로드 실패: \(error.localizedDescription)")
            }
        }
    }


}
