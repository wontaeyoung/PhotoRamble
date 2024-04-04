//
//  CreateDirectoryUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/21/24.
//

import RxSwift

protocol CreateDirectoryUsecase {
  
  func execute(directoryName: String) -> Single<Void>
}
