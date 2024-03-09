//
//  MapperError.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import KazUtility

enum MapperError: AppError {
  case toUUIDFailed(from: String)
  
  var logDescription: String {
    switch self {
      case .toUUIDFailed(let from):
        return "UUID 변환 실패 from: \(from)"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .toUUIDFailed:
        return "데이터를 불러오는데 실패했어요. 문제가 지속되면 개발자에게 알려주세요."
    }
  }
}
