//
//  WalkRepository.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import RxSwift

protocol WalkRepository {
  
  func create(with walk: Walk) -> Single<Walk>
}
