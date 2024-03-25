//
//  CanAccessCameraUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/26/24.
//

import RxSwift

final class CanAccessCameraUsecaseImpl: CanAccessCameraUsecase {
  
  // MARK: - Property
  private let appPermissionRepository: any AppPermissionRepository
  
  // MARK: - Initializer
  init(appPermissionRepository: some AppPermissionRepository) {
    self.appPermissionRepository = appPermissionRepository
  }
  
  // MARK: - Method
  func execute() -> Single<Bool> {
    return appPermissionRepository.isCameraAuthorized()
  }
}
