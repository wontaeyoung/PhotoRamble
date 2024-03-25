//
//  AppInfoRepository.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import RxSwift

protocol AppInfoRepository {
  
  func fetchVersion() -> Single<String>
}
