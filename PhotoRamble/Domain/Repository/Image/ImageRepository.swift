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
}

