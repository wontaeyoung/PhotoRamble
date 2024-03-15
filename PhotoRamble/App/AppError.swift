//
//  AppError.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

public protocol AppError: Error {
  var logDescription: String { get }
  var alertDescription: String { get }
}

public enum CommonError: AppError {
  
  case unknownError(error: Error?)
  case unExceptedNil
  
  public var logDescription: String {
    switch self {
      case .unknownError(let error):
        return "알 수 없는 오류 발생 \(error?.localizedDescription ?? "")"
        
      case .unExceptedNil:
        return "Nil 객체 발생"
    }
  }
  
  public var alertDescription: String {
    switch self {
      case .unknownError, .unExceptedNil:
        return "알 수 없는 문제가 발생했어요. 문제가 지속되면 개발자에게 알려주세요."
    }
  }
}
