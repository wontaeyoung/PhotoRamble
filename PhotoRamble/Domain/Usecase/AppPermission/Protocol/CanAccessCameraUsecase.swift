//
//  CanAccessCameraUsecase.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/26/24.
//

import RxSwift

protocol CanAccessCameraUsecase {
  
  func execute() -> Single<Bool>
}
