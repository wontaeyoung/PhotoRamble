//
//  StartWalkSplashViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/4/24.
//

import RxSwift
import RxCocoa

final class StartWalkSplashViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let animationCompleteEvent: PublishRelay<Void>
  }
  
  struct Output { }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    input.animationCompleteEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showWalkInProgressView()
      }
      .disposed(by: disposeBag)
    
    return Output()
  }
}

