//
//  SettingViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import RxSwift
import RxCocoa

final class SettingViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: SettingCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    return Output()
  }
}

