//
//  PRError.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

enum PRError {
  
  enum ImageFile: AppError {
    
    case createFailed(error: Error)
    case createListFailed(error: Error)
    case clearFailed(error: Error)
    
    var logDescription: String {
      switch self {
        case .createFailed(let error):
          return "이미지 파일 저장 실패. \(error.localizedDescription)"
        case .createListFailed(let error):
          return "이미지 파일 리스트 저장 실패. \(error.localizedDescription)"
        case .clearFailed(let error):
          return "이미지 파일 전체 삭제 실패. \(error.localizedDescription)"
      }
    }
    
    var alertDescription: String {
      switch self {
        case .createFailed, .createListFailed:
          return "이미지를 저장하는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
          
        case .clearFailed:
          return "이미지를 정리하는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
      }
    }
  }
}
