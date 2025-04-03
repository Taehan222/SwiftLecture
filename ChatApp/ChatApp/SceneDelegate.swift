//
//  SceneDelegate.swift
//  ChatApp
//
//  Created by 윤태한 on 4/3/25.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // Scene이 실행될 때 호출되는 함수
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Firebase 초기화 (중복 방지)
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // UIWindow 설정 및 초기 뷰 컨트롤러 설정
        window = UIWindow(windowScene: windowScene)
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // 앱이 백그라운드에서 활성화될 때 호출
    func sceneDidBecomeActive(_ scene: UIScene) {
        print("앱 활성화됨")
    }
    
    // 앱이 백그라운드로 이동할 때 호출
    func sceneWillResignActive(_ scene: UIScene) {
        print("앱 백그라운드로 이동")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

