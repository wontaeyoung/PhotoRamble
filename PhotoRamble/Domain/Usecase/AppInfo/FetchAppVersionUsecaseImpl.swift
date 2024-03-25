//
//  FetchAppVersionUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import RxSwift

final class FetchAppVersionUsecaseImpl: FetchAppVersionUsecase {
  
  // MARK: - Property
  private let appInfoRepository: any AppInfoRepository
  
  // MARK: - Initializer
  init(appInfoRepository: some AppInfoRepository) {
    self.appInfoRepository = appInfoRepository
  }
  
  // MARK: - Method
  func execute() -> Single<String> {
    return appInfoRepository.fetchVersion()
  }
}
