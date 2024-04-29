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
    let fetchResult = AppVersionUpdateService.fetchVersion()
    
    switch fetchResult {
      case .success(let version):
        return .just(version)
      case .failure(let error):
        return .error(error)
    }
  }
  
  func fetchNewVersionAvailable() -> Single<Bool> {
    return Single.create { single in
      Task {
        let fetchResult = await AppVersionUpdateService.isNewVersionAvailable()
        
        switch fetchResult {
          case .success(let available):
            single(.success(available))
          case .failure(let error):
            single(.failure(error))
        }
      }
      return Disposables.create()
    }
  }
}
