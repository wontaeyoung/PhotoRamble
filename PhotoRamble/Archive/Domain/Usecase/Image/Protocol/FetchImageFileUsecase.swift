//
//  FetchImageFileUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import Foundation
import RxSwift

protocol FetchImageFileUsecase {
  
  func execute(directoryName: String) -> Single<[Data]>
}

