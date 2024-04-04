//
//  AppPermissionRepository.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/26/24.
//

import RxSwift

protocol AppPermissionRepository {
  
  func isCameraAuthorized() -> Single<Bool>
}
