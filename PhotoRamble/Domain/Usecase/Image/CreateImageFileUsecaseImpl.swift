//
//  CreateImageFileUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation
import RxSwift

final class CreateImageFileUsecaseImpl: CreateImageFileUsecase {
  
  // MARK: - Property
  private let imageRepository: ImageRepository
  
  // MARK: - Initializer
  init(imageRepository: some ImageRepository) {
    self.imageRepository = imageRepository
  }
  
  // MARK: - Method
  func execute(imageData: Data, directoryName: String, fileIndex: Int) -> Single<Data> {
    return imageRepository.create(imageData: imageData, directoryName: directoryName, fileIndex: fileIndex)
  }
  
  func execute(imageDataList: [Data], directoryName: String) -> Single<[Data]> {
    return imageRepository.create(imageDataList: imageDataList, directoryName: directoryName)
  }
}
