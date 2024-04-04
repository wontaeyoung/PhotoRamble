//
//  SceneDelegate.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  private var coordinator: AppCoordinator?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let rootViewController = UINavigationController()
      .navigationLargeTitleEnabled()
      .navigationBarHidden()
    
    self.coordinator = AppCoordinator(rootViewController)
    
    self.window = UIWindow(windowScene: scene)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    
    coordinator?.start()
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    BindingContainer.shared.didEnterForegroundEvent.accept(())
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    BindingContainer.shared.didEnterBackgroundEvent.accept(())
  }
}
