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
  
  func create(imageDataList: [Data], directoryName: String) -> Single<[Data]> {
    
    do {
      try imageDataList.enumerated().forEach { fileIndex, imageData in
        let router = PhotoFileRouter(
          directory: directoryName,
          fileIndex: fileIndex,
          fileExtension: .jpg,
          fileMethod: .write
        )
        
        try PhotoFileManager.shared.writeImage(imageData: imageData, router: router)
      }
    } catch {
      return .error(PRError.ImageFile.createListFailed(error: error))
    }
    
    return .just(imageDataList)
  }
  
  func deleteAll(directoryName: String) -> Single<Void> {
    
    do {
      let router = PhotoFileRouter(
        directory: directoryName,
        fileIndex: 0, 
        fileExtension: .jpg,
        fileMethod: .delete
      )
      
      try PhotoFileManager.shared.removeAll(router: router)
    } catch {
      return .error(PRError.ImageFile.clearFailed(error: error))
    }
    
    return .just(())
  }
  
  func fetch(directoryName: String) -> Single<[Data]> {
    
    let router = PhotoFileRouter(
      directory: directoryName,
      fileIndex: 0,
      fileExtension: .jpg,
      fileMethod: .read
    )
    
    do {
      let dataList = try PhotoFileManager.shared.loadAllImages(router: router)
      
      return .just(dataList)
    } catch {
      return .error(PRError.ImageFile.loadFailed(error: error))
    }
  }
}
