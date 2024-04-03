//
//  AppError.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

internal protocol AppError: Error {
  var logDescription: String { get }
  var alertDescription: String { get }
}

internal enum CommonError: AppError {
  
  case unknownError(error: Error?)
  case unExceptedNil
  
  internal var logDescription: String {
    switch self {
      case .unknownError(let error):
        return "알 수 없는 오류 발생 \(error?.localizedDescription ?? "")"
        
      case .unExceptedNil:
        return "Nil 객체 발생"
    }
  }
  
  internal var alertDescription: String {
    switch self {
      case .unknownError, .unExceptedNil:
        return Localization.alert_unknown_error.localized
    }
  }
}
