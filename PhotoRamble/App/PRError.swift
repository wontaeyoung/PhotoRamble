//
//  PRError.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import Foundation

enum PRError {
  
  enum AppInfo: AppError {
    
    case invalidInfoKey(key: String)
    case invalidPattern
    
    var logDescription: String {
      switch self {
        case .invalidInfoKey(let key):
          return "InfoKey 유효성 없음 : \(key)"
          
        case .invalidPattern:
          return "정규식 패턴 미일치."
      }
    }
    
    var alertDescription: String {
      switch self {
        case .invalidInfoKey, .invalidPattern:
          return Localization.alert_fail_get_app_version_error.localized
      }
    }
  }
  
  enum ImageFile: AppError {
    
    case createFailed(error: Error)
    case createListFailed(error: Error)
    case clearFailed(error: Error)
    case removeFailed(error: Error)
    case loadFailed(error: Error)
    case createDirectoryFailed(error: Error)
    
    var logDescription: String {
      switch self {
        case .createFailed(let error):
          return "이미지 파일 저장 실패. \(error.localizedDescription)"
        case .createListFailed(let error):
          return "이미지 파일 리스트 저장 실패. \(error.localizedDescription)"
        case .clearFailed(let error):
          return "이미지 파일 전체 삭제 실패. \(error.localizedDescription)"
        case .removeFailed(let error):
          return "이미지 삭제 실패. \(error.localizedDescription)"
        case .loadFailed(let error):
          return "이미지 로드 실패. \(error.localizedDescription)"
        case .createDirectoryFailed(let error):
          return "디렉토리 생성 실패. \(error.localizedDescription)"
      }
    }
    
    var alertDescription: String {
      switch self {
        case .createFailed, .createListFailed:
          return Localization.alert_fail_create_image_error.localized
          
        case .clearFailed, .removeFailed:
          return Localization.alert_fail_delete_image_error.localized
          
        case .loadFailed:
          return Localization.alert_fail_fetch_image_error.localized
          
        case .createDirectoryFailed:
          return Localization.alert_unknown_error.localized
      }
    }
  }
  
  enum RealmRepository: AppError {
    
    case createFailed(error: Error, modelName: String)
    case fetchFailed(error: Error, modelName: String)
    case deleteAllFailed(error: Error, modelName: String)
    
    var logDescription: String {
      switch self {
        case .createFailed(let error, let name):
          return "\(name) Realm 인스턴스 저장 실패. \(error.localizedDescription)"
        
        case .fetchFailed(let error, let name):
          return "\(name) Realm 인스턴스 조회 실패. \(error.localizedDescription)"
          
        case .deleteAllFailed(let error, let name):
          return "\(name) Realm 테이블 삭제 실패. \(error.localizedDescription)"
      }
    }
    
    var alertDescription: String {
      switch self {
        case .createFailed(_, let name):
          return Localization.alert_fail_create_realm_error.localizedWith(name)
        
        case .fetchFailed(_, let name):
          return Localization.alert_fail_fetch_realm_error.localizedWith(name)
        
        case .deleteAllFailed(_, let name):
          return Localization.alert_fail_delete_realm_error.localizedWith(name)
      }
    }
  }
}
