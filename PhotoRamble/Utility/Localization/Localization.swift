//
//  Localization.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/8/24.
//

import Foundation

enum Localization: String {
  
  /// 네비게이션 타이틀
  case title_home_welcome_navigation
  
  /// 탭바 아이템 타이틀
  case tab_walk
  case tab_diary
  case tab_setting
  
  /// 인포 라벨 타이틀
  case label_no_photo_info
  case label_photo_selection_info
  case label_photo_selected_count_info
  
  /// 버튼 타이틀
  case button_walk_go
  case button_walk_start
  case button_walk_stop
  case button_walk_complete
  case button_photo_take
  case button_write_diary
  
  /// 알럿 타이틀
  case alert_cannot_over_max_selection
  case alert_unknown_error
  
  var localized: String {
    return NSLocalizedString(self.rawValue, comment: "")
  }
  
  func localizedWith(_ values: CVarArg...) -> String {
    return String(format: localized, values)
  }
}
