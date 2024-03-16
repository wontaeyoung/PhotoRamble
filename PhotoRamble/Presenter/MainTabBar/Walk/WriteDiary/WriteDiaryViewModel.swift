//
//  WriteDiaryViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import RxSwift
import RxCocoa

final class WriteDiaryViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output()
  }
}

