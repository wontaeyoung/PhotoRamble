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
    let requestCheckingCameraAccessEvent: PublishRelay<Void>
    let settingRowTapEvent: PublishRelay<IndexPath>
  }
  
  struct Output {
    let appVersion: Driver<String>
    let isCameraAuthorized: Driver<Bool>
    let showClearedDiaryToast: Driver<String>
  }
  
  // MARK: - Observable
  private let clearDiaryCompleted = PublishRelay<Int>()
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: SettingCoordinator?
  private let fetchAppVersionUsecase: any FetchAppVersionUsecase
  private let canAccessCameraUsecase: any CanAccessCameraUsecase
  private let deleteAllDiaryUsecase: any DeleteAllDiaryUsecase
  
  // MARK: - Initializer
  init(
    fetchAppVersionUsecase: some FetchAppVersionUsecase,
    canAccessCameraUsecase: some CanAccessCameraUsecase,
    deleteAllDiaryUsecase: some DeleteAllDiaryUsecase
  ) {
    self.fetchAppVersionUsecase = fetchAppVersionUsecase
    self.canAccessCameraUsecase = canAccessCameraUsecase
    self.deleteAllDiaryUsecase = deleteAllDiaryUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let appVersion = BehaviorRelay<String>(value: "-")
    let isCameraAuthorized = BehaviorRelay<Bool>(value: false)
    let showClearedDiaryToast = BehaviorRelay<String>(value: "")
    
    BindingContainer.shared.didEnterForegroundEvent
      .bind(to: input.requestCheckingCameraAccessEvent)
      .disposed(by: disposeBag)
    
    fetchAppVersionUsecase.execute()
      .map { "v " + $0 }
      .subscribe(with: self) { owner, version in
        appVersion.accept(version)
      } onFailure: { owner, error in
        LogManager.shared.log(with: error, to: .local)
        owner.coordinator?.showErrorAlert(error: error)
      }
      .disposed(by: disposeBag)
    
    clearDiaryCompleted
      .map { "\($0)개의 일기가 삭제 완료됐어요!" }
      .do { _ in
        BindingContainer.shared.diaryTableUpdatedEvent.accept(())
      }
      .bind(to: showClearedDiaryToast)
      .disposed(by: disposeBag)
    
    input.requestCheckingCameraAccessEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.canAccessCameraUsecase.execute()
      }
      .subscribe(with: self) { owner, canAccess in
        isCameraAuthorized.accept(canAccess)
      }
      .disposed(by: disposeBag)
    
    input.settingRowTapEvent
      .bind(with: self) { owner, indexPath in
        owner.handleSettingTapEvent(at: indexPath)
      }
      .disposed(by: disposeBag)
    
    return Output(
      appVersion: appVersion.asDriver(),
      isCameraAuthorized: isCameraAuthorized.asDriver(),
      showClearedDiaryToast: showClearedDiaryToast.asDriver()
    )
  }
  
  private func handleSettingTapEvent(at indexPath: IndexPath) {
    
    let row = SettingSection.row(at: indexPath)
    
    switch row {
      case .camera:
        requestOpenSettingAlert()
        
      case .privacy:
        coordinator?.showSettingWebView(webCase: .privacy)
        
      case .openSource:
        coordinator?.showSettingWebView(webCase: .openSource)
      
      case .clearDiary:
        showClearDiaryAlert()
      
      case .version:
        break
    }
  }
  
  private func requestOpenSettingAlert() {
    
  }
  
  private func showClearDiaryAlert() {
    coordinator?.showAlert(
      title: "일기 삭제 안내",
      message: "삭제된 일기는 다시 복구할 수 없어요. 정말 삭제하시겠어요?",
      okStyle: .destructive,
      isCancelable: true
    ) { [weak self] in
      guard let self else { return }
      
      deleteAllDiaryUsecase.execute()
        .subscribe(with: self) { owner, diaries in
          owner.clearDiaryCompleted.accept(diaries.count)
        } onFailure: { owner, error in
          owner.coordinator?.showErrorAlert(error: error)
          LogManager.shared.log(with: error, to: .local)
        }
        .disposed(by: disposeBag)
    }
  }
}
