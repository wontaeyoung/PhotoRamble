//
//  CreateImageFileUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation
import RxSwift

protocol CreateImageFileUsecase {
  
  func execute(imageData: Data, directoryName: String, fileIndex: Int) -> Single<Data>
  func execute(imageDataList: [Data], directoryName: String) -> Single<[Data]>
}
