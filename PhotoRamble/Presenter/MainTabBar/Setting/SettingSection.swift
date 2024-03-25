//
//  SettingSection.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import UIKit

enum SettingSection: Int, CaseIterable {
  
  case access
  case about
  
  var title: String {
    switch self {
      case .access:
        return "앱 권한 설정"
        
      case .about:
        return "기타"
    }
  }
  
  var rows: [Row] {
    switch self {
      case .access:
        return [.camera]
        
      case .about:
        return [.terms, .openSource, .clearDiary, .version]
    }
  }
  
  enum Row {
    
    case camera
    
    case terms
    case openSource
    case clearDiary
    case version
    
    var title: String {
      switch self {
        case .camera:
          return "카메라 사용"
          
        case .terms:
          return "약관 및 개인정보 처리 방침"
          
        case .openSource:
          return "오픈소스 라이선스"
          
        case .clearDiary:
          return "모든 일기 삭제하기"
          
        case .version:
          return "앱 버전"
      }
    }
    
    var subTitle: String {
      switch self {
        case .camera:
          return "산책하면서 사진을 찍을 때 필요해요"
          
        default:
          return ""
      }
    }
    
    var icon: UIImage? {
      switch self {
        case .camera:
          return PRAsset.Symbol.useCameraConfigIcon
          
        case .terms:
          return PRAsset.Symbol.termsConfigIcon
          
        case .openSource:
          return PRAsset.Symbol.licenseConfigIcon
          
        case .clearDiary:
          return PRAsset.Symbol.deleteAllDiaryConfigIcon
          
        case .version:
          return nil
      }
    }
  }
  
  func row(at indexPath: IndexPath) -> Row {
    return SettingSection.allCases[indexPath.section].rows[indexPath.row]
  }
}
