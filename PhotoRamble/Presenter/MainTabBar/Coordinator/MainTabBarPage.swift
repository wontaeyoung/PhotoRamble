//
//  MainTabBarPage.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit

enum MainTabBarPage: Int, CaseIterable {
  case walk
  case diary
  case setting
  
  var index: Int {
    self.rawValue
  }
  
  var navigationTitle: String {
    switch self {
      case .walk:
        return Localization.tab_walk.localized
      case .diary:
        return Localization.tab_diary.localized
      case .setting:
        return Localization.tab_setting.localized
    }
  }
  
  var title: String {
    switch self {
      case .walk:
        return Localization.tab_walk.localized
      case .diary:
        return Localization.tab_diary.localized
      case .setting:
        return Localization.tab_setting.localized
    }
  }
  
  var icon: UIImage? {
    switch self {
      case .walk:
        return PRAsset.Symbol.walkTabIcon
      case .diary:
        return PRAsset.Symbol.diaryTabIcon
      case .setting:
        return PRAsset.Symbol.configTabIcon
    }
  }
  
  var selectedIcon: UIImage? {
    switch self {
      case .walk:
        return PRAsset.Symbol.walkSelectedTabIcon
      case .diary:
        return PRAsset.Symbol.diarySelectedTabIcon
      case .setting:
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

