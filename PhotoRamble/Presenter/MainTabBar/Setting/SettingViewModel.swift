//
//  SettingViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import RxSwift
import RxCocoa
import AVFoundation

final class SettingViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    let appVersion: Driver<String>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: SettingCoordinator?
  private let fetchAppVersionUsecase: any FetchAppVersionUsecase
  
  // MARK: - Initializer
  init(fetchAppVersionUsecase: some FetchAppVersionUsecase) {
    self.fetchAppVersionUsecase = fetchAppVersionUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let appVersion = BehaviorRelay<String>(value: "-")
    
    fetchAppVersionUsecase.execute()
      .map { "v " + $0 }
      .subscribe(with: self) { owner, version in
        appVersion.accept(version)
      } onFailure: { owner, error in
        LogManager.shared.log(with: error, to: .local)
        owner.coordinator?.showErrorAlert(error: error)
      }
      .disposed(by: disposeBag)
    
    return Output(
      appVersion: appVersion.asDriver()
    )
  }
}
