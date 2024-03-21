//
//  WalkInProgressViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WalkInProgressViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let takenNewPhotoDataEvent: PublishRelay<Data>
    let walkCompleteButtonTapEvent: PublishRelay<Void>
  }
  
  struct Output {
    let imageDataList: Driver<[Data]>
    let timerLabelText: Signal<String>
  }
  
  // MARK: - Observable
  private let walkRelay = BehaviorRelay<Walk>(value: Walk())
  private let imagesDataRelay = BehaviorRelay<[Data]>(value: [])
  private let timeIntervalRelay = BehaviorRelay<TimeInterval>(value: 0)
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  private let createImageFileUsecase: any CreateImageFileUsecase
  private let createDirectoryUsecase: any CreateDirectoryUsecase
  
  var numberOfItems: Int {
    return imagesDataRelay.value.count
  }
  
  // MARK: - Initializer
  init(
    createImageFileUsecase: some CreateImageFileUsecase,
    createDirectoryUsecase: some CreateDirectoryUsecase
  ) {
    self.createImageFileUsecase = createImageFileUsecase
    self.createDirectoryUsecase = createDirectoryUsecase
  }
  
  deinit {
#if DEBUG
    LogManager.shared.log(with: "\(self) 해제", to: .local, level: .debug)
#endif
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    input.takenNewPhotoDataEvent
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .withUnretained(self)
      .flatMap { owner, data in
        return owner.createImageFileUsecase.execute(
          imageData: data,
          directoryName: owner.walkRelay.value.id.uuidString,
          fileIndex: owner.imagesDataRelay.value.count
        )
      }
      .observe(on: MainScheduler.instance)
      .subscribe(with: self, onNext: { owner, data in
        owner.updateImageDataList(with: data)
      }, onError: { owner, error in
        LogManager.shared.log(with: error, to: .local)
        owner.coordinator?.showErrorAlert(error: error)
      })
      .disposed(by: disposeBag)
    
    input.walkCompleteButtonTapEvent
      .withLatestFrom(imagesDataRelay)
      .subscribe(with: self, onNext: { owner, dataList in
        owner.processCompleteEvent(imageDataList: dataList)
      })
      .disposed(by: disposeBag)
    
    let timerText: Signal<String> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .withUnretained(self) { owner, _ in
        owner.timerTick()
        return owner.getTimerText()
      }
      .asSignal(onErrorJustReturn: "타이머 표시 오류가 발생했어요.")
    
    return Output(
      imageDataList: imagesDataRelay.asDriver(),
      timerLabelText: timerText
    )
  }
  
  private func timerTick() {
    timeIntervalRelay.accept(timeIntervalRelay.value + 1)
  }
  
  private func updateImageDataList(with newData: Data) {
    var currentList = imagesDataRelay.value
    currentList.append(newData)
    
    imagesDataRelay.accept(currentList)
  }
  
  private func processCompleteEvent(imageDataList: [Data]) {
    if imageDataList.isEmpty {
      showAgreementAlert()
    } else {
      prepareWalkForNextFlow()
      
      coordinator?.showWalkPhotoSelectionView(
        walkRealy: walkRelay,
        imageDataList: imageDataList
      )
    }
  }
  
  private func showAgreementAlert() {
    coordinator?.showAlert(
      title: "산책 종료 안내",
      message: "아직 촬영한 사진이 없어요. 정말 산책을 종료할까요?",
      isCancelable: true
    ) { [weak self] in
      guard let self else { return }
      prepareWalkForNextFlow()
      
      let walk = walkRelay.value
      let initialDiary: Diary = .initialDiary(photoIndicies: [], walkID: walk.id)
      coordinator?.showWriteDiaryView(walk: walk, diary: initialDiary, imageDataList: [])
      
      createDirectoryUsecase.execute(directoryName: walk.id.uuidString)
        .subscribe(with: self, onFailure: { owner, error in
          LogManager.shared.log(with: error, to: .local)
        })
        .disposed(by: disposeBag)
    }
  }
  
  private func prepareWalkForNextFlow() {
    let updatedWalk = walkRelay.value.applied {
      $0.endAt = .now
      $0.walkDuration = timeIntervalRelay.value.toSeconds
    }
    
    walkRelay.accept(updatedWalk)
  }
  
  private func getTimerText() -> String {
    return DateManager.shared.elapsedTime(timeIntervalRelay.value, format: .HHmmss)
  }
  
  func timerButtonTitle(isOn: Bool) -> String {
    return isOn
    ? Localization.walk_stop_button.localized
    : Localization.walk_start_button.localized
  }
  
  func requestImageForSimulator() -> Observable<Data> {
    
    //    let width = Int.random(in: 5...10) * 200
    //    let height = width + Int.random(in: -5...0) * 100
    let width = 500
    let height = 500
    let url = "https://picsum.photos/\(width)/\(height)"
    
#if DEBUG
    LogManager.shared.log(with: "요청 URL : " + url, to: .local, level: .debug)
#endif
    
    return Observable.just(url)
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .compactMap { URL(string: $0) }
      .compactMap { try Data(contentsOf: $0) }
  }
}
