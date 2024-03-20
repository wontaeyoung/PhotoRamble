//
//  WalkRepositoryImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/19/24.
//

import Foundation
import KazRealm
import RealmSwift
import RxSwift

final class WalkRepositoryImpl: WalkRepository {
  
  private let service: any RealmService
  private let mapper: WalkMapper
  
  init(service: RealmService, mapper: WalkMapper) {
    self.service = service
    self.mapper = mapper
  }
  
  func create(with walk: Walk) -> Single<Walk> {
    
    let walkDTO = mapper.toDTO(walk)
    
    do {
      try service.create(with: walkDTO)
      return .just(walk)
    } catch {
      return .error(PRError.RealmRepository.createFailed(error: error, modelName: "산책"))
    }
  }
}
