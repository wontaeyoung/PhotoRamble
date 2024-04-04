//
//  CreateWalkUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import RxSwift

protocol CreateWalkUsecase {
  
  func execute(with walk: Walk) -> Single<Walk>
}
