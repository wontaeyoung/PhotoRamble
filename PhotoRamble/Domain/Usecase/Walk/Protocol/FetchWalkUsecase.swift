//
//  FetchWalkUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/24/24.
//

import Foundation
import RxSwift

protocol FetchWalkUsecase {
  
  func execute(walkID: UUID) -> Single<Walk>
}
