//
//  FetchImageFileUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import Foundation
import RxSwift

final class FetchImageFileUsecaseImpl: FetchImageFileUsecase {
  
  // MARK: - Property
  private let imageRepository: ImageRepository
  
  // MARK: - Initializer
  init(imageRepository: some ImageRepository) {
    self.imageRepository = imageRepository
  }
  
  // MARK: - Method
  func execute(directoryName: String) -> Single<[Data]> {
    return imageRepository.fetch(directoryName: directoryName)
  }
}

