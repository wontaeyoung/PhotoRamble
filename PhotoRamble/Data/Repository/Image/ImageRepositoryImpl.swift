//
//  ImageRepositoryImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation
import RxSwift

final class ImageRepositoryImpl: ImageRepository {
  
  func create(imageData: Data, directoryName: String, fileIndex: Int) -> Single<Data> {
    
    let router = PhotoFileRouter(
      directory: directoryName,
      fileIndex: fileIndex,
      fileExtension: .jpg,
      fileMethod: .write
    )
    
    do {
      try PhotoFileManager.shared.writeImage(imageData: imageData, router: router)
      
      return .just(imageData)
    } catch {
      return .error(error)
    }
  }
}
