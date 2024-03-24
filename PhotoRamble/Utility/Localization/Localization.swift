//
//  Localization.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/8/24.
//

import Foundation

enum Localization: String {
  
  /// 네비게이션 타이틀
  case home_welcome_navigation_title
  
  /// 탭바 아이템 타이틀
  case tab_walk
  case tab_diary
  case tab_setting
  
  /// 인포 라벨 타이틀
  case no_photo_info_label
  case photo_selection_info_label
  case photo_selected_count_info_label
  
  /// 버튼 타이틀
  case walk_go_button
  case walk_start_button
  case walk_stop_button
  case walk_complete_button
  case photo_take_button
  case write_diary_button
  
  /// 알럿 타이틀
  case cannot_over_max_selection_alert
  
  var localized: String {
    return NSLocalizedString(self.rawValue, comment: "")
  }
  
  func localizedWith(_ values: CVarArg...) -> String {
    return String(format: localized, values)
  }
}
