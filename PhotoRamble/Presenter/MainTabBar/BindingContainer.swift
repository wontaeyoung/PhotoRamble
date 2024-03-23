//
//  BindingContainer.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/23/24.
//

import RxSwift
import RxRelay
import KazRealm

final class BindingContainer {
  
  static let shared: BindingContainer = BindingContainer()
  private init() { }
  
  let diaryTableUpdatedEvent = PublishRelay<Void>()
}
