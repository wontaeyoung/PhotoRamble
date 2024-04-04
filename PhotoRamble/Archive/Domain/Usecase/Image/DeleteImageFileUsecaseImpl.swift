//
//  DeleteImageFileUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import Foundation
import RxSwift

final class DeleteImageFileUsecaseImpl: DeleteImageFileUsecase {
  
  // MARK: - Property
  private let imageRepository: ImageRepository
  
  // MARK: - Initializer
  init(imageRepository: some ImageRepository) {
    self.imageRepository = imageRepository
  }
  
  // MARK: - Method
  func execute(directoryName: String) -> Single<Void> {
    return imageRepository.deleteAll(directoryName: directoryName)
  }
  
  func execute(directoryName: String, fileIndex: Int) -> Single<Int> {
    return imageRepository.delete(directoryName: directoryName, fileIndex: fileIndex)
  }
}
