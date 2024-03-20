//
//  DiaryRepository.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import RxSwift

protocol DiaryRepository {
  
  func create(with diary: Diary) -> Single<Diary>
  func fetch() -> Single<[Diary]>
}

