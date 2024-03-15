//
//  ReplaceImageFileUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import Foundation
import RxSwift

final class ReplaceImageFileUsecaseImpl: ReplaceImageFileUsecase {
  
  // MARK: - Property
  private let imageRepository: ImageRepository
  
  // MARK: - Initializer
  init(imageRepository: some ImageRepository) {
    self.imageRepository = imageRepository
  }
  
  // MARK: - Method
  func excute(imageDataList: [Data], directoryName: String) -> Single<[Data]> {
    return imageRepository.deleteAll(directoryName: directoryName)
      .flatMap { self.imageRepository.create(imageDataList: imageDataList, directoryName: directoryName) }
  }
}
