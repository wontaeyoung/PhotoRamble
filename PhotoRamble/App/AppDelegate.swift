//
//  AppDelegate.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    connectFirebase()
    setGlobalNavigationBarAppearance()
    
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  private func connectFirebase() {
    FirebaseApp.configure()
  }
  
  private func setGlobalNavigationBarAppearance() {
    
    UINavigationBar.appearance().configure {
      let appearance = UINavigationBarAppearance().configured {
        $0.backgroundColor = PRAsset.Color.prPrimary
        $0.titleTextAttributes = [.foregroundColor:PRAsset.Color.prWhite]
        $0.largeTitleTextAttributes = [.foregroundColor:PRAsset.Color.prWhite]
      }
      
      $0.tintColor = PRAsset.Color.prWhite
      $0.barTintColor = PRAsset.Color.prWhite
      $0.standardAppearance = appearance
      $0.compactAppearance = appearance
      $0.scrollEdgeAppearance = appearance
      $0.compactScrollEdgeAppearance = appearance
    }
  }
}
