//
//  CreateDirectoryUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/21/24.
//

import RxSwift

final class CreateDirectoryUsecaseImpl: CreateDirectoryUsecase {
  
  // MARK: - Property
  private let imageRepository: ImageRepository
  
  // MARK: - Initializer
  init(imageRepository: some ImageRepository) {
    self.imageRepository = imageRepository
  }
  
  // MARK: - Method
  func execute(directoryName: String) -> Single<Void> {
    imageRepository.createDirectory(directoryName: directoryName)
  }
}
