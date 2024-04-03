//
//  PhotoFileError.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

enum FileManageError: AppError {
  
  static let contactDeveloperMessage: String = "문제가 지속되면 개발자에게 문의해주세요."
  
  case imageToDataFailed
  case writeDataFailed(error: Error)
  case createDirectoryFailed(error: Error)
  case fileNotExist(path: String)
  
  var logDescription: String {
    switch self {
      case .imageToDataFailed:
        return "파일 시스템 : 이미지 데이터 변환 실패"
        
      case .writeDataFailed(let error):
        return "파일 시스템 : 데이터 쓰기 실패 \(error.localizedDescription)"
        
      case .createDirectoryFailed(let error):
        return "파일 시스템 : 디렉토리 생성 실패 \(error.localizedDescription)"
        
      case .fileNotExist(let path):
        return "파일 시스템 : 파일이 존재하지 않음, 경로 : \(path)"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .imageToDataFailed:
        return Localization.alert_fail_convert_data_error.localized
        
      case .writeDataFailed:
        return Localization.alert_fail_write_data_error.localized
        
      case .createDirectoryFailed:
        return Localization.alert_fail_create_directory_error.localized
        
      case .fileNotExist:
        return Localization.alert_fail_find_file_error.localized
    }
  }
}
