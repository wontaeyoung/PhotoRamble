//
//  WalkRepository.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation
import RxSwift

protocol WalkRepository {
  
  func create(with walk: Walk) -> Single<Walk>
  func update(with walk: Walk) -> Single<Walk>
  func fetch() -> Single<[Walk]>
  func delete(at walkID: UUID) -> Single<Void>
}
