//
//  WalkViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import RxSwift
import RxRelay

final class WalkViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    var walkButtonTapEvent: PublishRelay<Void>
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
  @discardableResult
  func transform(input: Input) -> Output {
    
    input.walkButtonTapEvent
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.coordinator?.showStartWalkSplashView()
      })
      .disposed(by: disposeBag)
    
    return Output()
  }
}
