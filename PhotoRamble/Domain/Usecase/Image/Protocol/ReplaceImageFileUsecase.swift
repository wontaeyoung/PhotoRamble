//
//  ReplaceImageFileUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import Foundation
import RxSwift

protocol ReplaceImageFileUsecase {
  
  func excute(imageDataList: [Data], directoryName: String) -> Single<[Data]>
}
