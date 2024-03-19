//
//  DeleteImageFileUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import RxSwift

protocol DeleteImageFileUsecase {
  
  func execute(directoryName: String) -> Single<Void>
}
