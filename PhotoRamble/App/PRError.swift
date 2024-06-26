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
          return "앱 버전을 가져오는데 실패했어요!"
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
          return "이미지를 저장하는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
          
        case .clearFailed, .removeFailed:
          return "이미지를 정리하는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
          
        case .loadFailed:
          return "이미지를 불러오는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
          
        case .createDirectoryFailed:
          return "알 수 없는 문제가 발생했어요. 문제가 지속되면 개발자에게 알려주세요."
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
          return "\(name) 내용을 저장하는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
        
        case .fetchFailed(_, let name):
          return "\(name) 내용을 불러오는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
        
        case .deleteAllFailed(_, let name):
          return "\(name) 내용들을 삭제하는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
      }
    }
  }
}
