//
//  AppInfoRepositoryImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import Foundation
import RxSwift

final class AppInfoRepositoryImpl: AppInfoRepository {
  
  func fetchVersion() -> Single<String> {
    guard var currentVersion = Bundle.main.object(forInfoDictionaryKey: Constant.InfoKey.versionString) as? String else {
      return .error(PRError.AppInfo.invalidInfoKey(key: Constant.InfoKey.versionString))
    }
    
    if currentVersion.components(separatedBy: ".").count <= 2 {
        currentVersion += ".0"
    }
    
    guard isValidPattern(text: currentVersion, pattern: Constant.RegPattern.appVersion) else {
      return .error(PRError.AppInfo.invalidPattern)
    }
    
    return .just(currentVersion)
  }
  
  private func isValidPattern(text: String, pattern: String) -> Bool {
    return text.range(of: pattern, options: .regularExpression) != nil
  }
}
