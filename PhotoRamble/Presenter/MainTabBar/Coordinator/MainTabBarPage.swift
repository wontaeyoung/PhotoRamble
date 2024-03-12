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
        return Localization.tab_walk.localized
      case .post:
        return Localization.tab_diary.localized
      case .config:
        return Localization.tab_config.localized
    }
  }
  
  var title: String {
    switch self {
      case .walk:
        return Localization.tab_walk.localized
      case .post:
        return Localization.tab_diary.localized
      case .config:
        return Localization.tab_config.localized
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
      title: title,
      image: icon,
      selectedImage: selectedIcon
    )
  }
}

