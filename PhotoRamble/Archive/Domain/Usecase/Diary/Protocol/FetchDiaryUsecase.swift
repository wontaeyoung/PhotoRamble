//
//  FetchDiaryUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import RxSwift

protocol FetchDiaryUsecase {
  
  func execute() -> Single<[Diary]>
}
