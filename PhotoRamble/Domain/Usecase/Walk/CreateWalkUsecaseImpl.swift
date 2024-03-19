//
//  CreateWalkUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/19/24.
//

import Foundation
import RxSwift

final class CreateWalkUsecaseImpl: CreateWalkUsecase {
  
  // MARK: - Property
  private let walkRepository: any WalkRepository
  
  // MARK: - Initializer
  init(walkRepository: some WalkRepository) {
    self.walkRepository = walkRepository
  }
  
  // MARK: - Method
  func execute(with walk: Walk) -> Single<Walk> {
    return walkRepository.create(with: walk)
  }
}

