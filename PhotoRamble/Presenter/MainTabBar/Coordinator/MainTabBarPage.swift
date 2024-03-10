//
//  MainTabBarPage.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit

enum MainTabBarPage: Int, CaseIterable {
  case walk
  case post
  case config
  
  var index: Int {
    self.rawValue
  }
  
  var navigationTitle: String {
    switch self {
      case .walk:
        return Localization.home_welcome_navigation_title.localizedWith("원태영")
      case .post:
        return Localization.diary.localized
      case .config:
        return Localization.config.localized
    }
  }
  
  var icon: UIImage? {
    switch self {
      case .walk:
        return PRAsset.Symbol.walkTabIcon
      case .post:
        return PRAsset.Symbol.diaryTabIcon
      case .config:
        return PRAsset.Symbol.configTabIcon
    }
  }
  
  var selectedIcon: UIImage? {
    switch self {
      case .walk:
        return PRAsset.Symbol.walkSelectedTabIcon
      case .post:
        return PRAsset.Symbol.diarySelectedTabIcon
      case .config:
        return PRAsset.Symbol.configSelectedTabIcon
    }
  }
  
  var tabBarItem: UITabBarItem {
    return UITabBarItem(
      title: nil,
      image: icon,
      selectedImage: selectedIcon
    )
  }
}

