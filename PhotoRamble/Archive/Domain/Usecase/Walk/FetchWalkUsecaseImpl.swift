//
//  FetchWalkUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/24/24.
//

import Foundation
import RxSwift

final class FetchWalkUsecaseImpl: FetchWalkUsecase {
  
  // MARK: - Property
  private let walkRepository: any WalkRepository
  
  // MARK: - Initializer
  init(walkRepository: some WalkRepository) {
    self.walkRepository = walkRepository
  }
  
  // MARK: - Method
  func execute(walkID: UUID) -> Single<Walk> {
    return walkRepository.fetch(walkID: walkID)
  }
}
