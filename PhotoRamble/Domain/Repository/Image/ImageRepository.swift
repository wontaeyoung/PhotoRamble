//
//  ImageRepository.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation
import RxSwift

protocol ImageRepository {
  
  func create(imageData: Data, directoryName: String, fileIndex: Int) -> Single<Data>
  func create(imageDataList: [Data], directoryName: String) -> Single<[Data]>
  func deleteAll(directoryName: String) -> Single<Void>
  func delete(directoryName: String, fileIndex: Int) -> Single<Int>
  func fetch(directoryName: String) -> Single<[Data]>
  func createDirectory(directoryName: String) -> Single<Void>
}
