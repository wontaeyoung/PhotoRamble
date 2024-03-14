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
    let viewDidLoadEvent: Observable<Bool>
    let takenNewPhotoDataEvent: PublishRelay<Data>
    let timerToggleEvent: PublishRelay<Void>
  }
  
  struct Output {
    let imageDataList: Driver<[Data]>
    let timerButtonText: Signal<String>
    let timerLabelText: Signal<String>
  }
  
  // MARK: - Observable
  private let walkRelay = BehaviorRelay<Walk>(value: Walk())
  private let imagesDataRelay = BehaviorRelay<[Data]>(value: [])
  private let timerStateRelay = BehaviorRelay<Bool>(value: false)
  private let timeIntervalRelay = BehaviorRelay<TimeInterval>(value: 0)
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  private let createImageFileUsecase: CreateImageFileUsecase
  
  var numberOfItems: Int {
    return imagesDataRelay.value.count
  }
  
  // MARK: - Initializer
  init(createImageFileUsecase: some CreateImageFileUsecase) {
    self.createImageFileUsecase = createImageFileUsecase
  }
  
  deinit {
#if DEBUG
    LogManager.shared.log(with: "\(self) 해제", to: .local, level: .debug)
#endif
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    input.viewDidLoadEvent
      .bind(to: timerStateRelay)
      .disposed(by: disposeBag)
    
    input.takenNewPhotoDataEvent
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .withUnretained(self)
      .flatMap { owner, data in
        return owner.createImageFileUsecase.excute(
          imageData: data,
          directoryName: owner.walkRelay.value.id.uuidString,
          fileIndex: owner.imagesDataRelay.value.count
        )
      }
      .observe(on: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(
        onNext: { owner, data in
          owner.updateImageDataList(with: data)
        },
        onError: { [weak self] error in
          guard let self else { return }
          
          LogManager.shared.log(with: error, to: .local)
          coordinator?.showErrorAlert(error: error)
        }
      )
      .disposed(by: disposeBag)
    
    input.timerToggleEvent
      .withLatestFrom(timerStateRelay)
      .withUnretained(self)
      .subscribe(onNext: { owner, isRunning in
        owner.timerStateRelay.accept(!isRunning)
      })
      .disposed(by: disposeBag)
    
    let timerButtonText: Signal<String> = timerStateRelay
      .withUnretained(self)
      .map { owner, on in
        return owner.timerButtonTitle(isOn: on)
      }
      .asSignal(onErrorJustReturn: "")
    
    let timerText: Signal<String> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .withLatestFrom(timerStateRelay)
      .filter { $0 }
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.timerTick()
        
        let timerText = DateManager.shared.elapsedTime(owner.timeIntervalRelay.value, format: .HHmmss)
        return Observable.just(timerText)
      }
      .asSignal(onErrorJustReturn: "타이머 표시 오류가 발생했습니다.")
    
    return Output(
      imageDataList: imagesDataRelay.asDriver(),
      timerButtonText: timerButtonText,
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
