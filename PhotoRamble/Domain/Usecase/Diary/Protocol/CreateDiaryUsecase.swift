//
//  CreateDiaryUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import RxSwift

protocol CreateDiaryUsecase {
  
  func execute(with diary: Diary) -> Single<Diary>
}
