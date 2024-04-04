//
//  FetchAppVersionUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import RxSwift

protocol FetchAppVersionUsecase {
  
  func execute() -> Single<String>
}
