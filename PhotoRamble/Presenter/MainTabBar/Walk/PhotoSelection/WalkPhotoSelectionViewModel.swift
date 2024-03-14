//
//  WalkPhotoSelectionViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import RxSwift
import RxCocoa

final class WalkPhotoSelectionViewModel: ViewModel {
  
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
