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
  func fetch(walkID: UUID) -> Single<Walk>
}
