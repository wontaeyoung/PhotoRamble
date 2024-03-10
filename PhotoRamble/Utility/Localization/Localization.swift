//
//  Localization.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/8/24.
//

import Foundation

enum Localization: String {
  
  case home_welcome_navigation_title
  
  /// 탭바 아이템 타이틀
  case walk
  case diary
  case config
  
  var localized: String {
    return NSLocalizedString(self.rawValue, comment: "")
  }
  
  func localizedWith(_ values: CVarArg...) -> String {
    return String(format: localized, values)
  }
}
