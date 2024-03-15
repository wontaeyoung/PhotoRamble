//
//  CreateImageFileUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation
import RxSwift

protocol CreateImageFileUsecase {
  
  func excute(imageData: Data, directoryName: String, fileIndex: Int) -> Single<Data>
  func excute(imageDataList: [Data], directoryName: String) -> Single<[Data]>
}
