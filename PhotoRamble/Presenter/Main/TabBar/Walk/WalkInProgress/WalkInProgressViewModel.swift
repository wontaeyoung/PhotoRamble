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
    let viewDidLoadEvent: PublishRelay<Void>
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
  private let imageRepository: any ImageRepository
  private let walkRepository: any WalkRepository
  private var timer: Timer?
  private var backgroundTimeIntervalManager = BackgroundTimeIntervalManager()
  
  var numberOfItems: Int {
    return imagesDataRelay.value.count
  }
  
  private var photoDirectoryName: String {
    return walkRelay.value.id.uuidString
  }
  
  private var currentFileIndex: Int {
    return imagesDataRelay.value.count
  }
  
  // MARK: - Initializer
  init(
    imageRepository: some ImageRepository,
    walkRepository: some WalkRepository
  ) {
    self.imageRepository = imageRepository
    self.walkRepository = walkRepository
  }
  
  deinit {
    clearTimer()

#if DEBUG
    LogManager.shared.log(with: "\(self) 해제", to: .local, level: .debug)
#endif
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let timerText = timeIntervalRelay
      .withUnretained(self)
      .map { owner, interval in
        return owner.getTimerText(interval: interval)
      }
    
    input.viewDidLoadEvent
      .bind(with: self) { owner, _ in
        owner.startTimer()
      }
      .disposed(by: disposeBag)
    
    input.takenNewPhotoDataEvent
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .withUnretained(self)
      .flatMap { owner, data in
        return owner.imageRepository.create(
          imageData: data,
          directoryName: owner.photoDirectoryName,
          fileIndex: owner.currentFileIndex
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
      .bind(with: self) { owner, dataList in
        owner.processCompleteEvent(imageDataList: dataList)
      }
      .disposed(by: disposeBag)
    
    BindingContainer.shared.didEnterBackgroundEvent
      .bind(with: self) { owner, _ in
        owner.logLeaveForegroundTime()
      }
      .disposed(by: disposeBag)
    
    BindingContainer.shared.didEnterForegroundEvent
      .bind(with: self) { owner, _ in
        owner.addBackgroundTimeInterval()
      }
      .disposed(by: disposeBag)
    
    return Output(
      imageDataList: imagesDataRelay.asDriver(),
      timerLabelText: timerText.asSignal(onErrorJustReturn: "--:--:--")
    )
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
      title: "산책 완료 안내",
      message: "아직 촬영한 사진이 없어요. 산책을 끝내고 일기를 쓰러 가볼까요?",
      isCancelable: true
    ) { [weak self] in
      guard let self else { return }
      prepareWalkForNextFlow()
      
      let walk = walkRelay.value
      let initialDiary: Diary = .initialDiary(photoIndicies: [], walk: walk)
      coordinator?.showWriteDiaryView(walk: walk, diary: initialDiary, imageDataList: [])
      
      imageRepository.createDirectory(directoryName: photoDirectoryName)
        .subscribe(with: self, onFailure: { owner, error in
          LogManager.shared.log(with: error, to: .local)
        })
        .disposed(by: disposeBag)
      
      walkRepository.create(with: walk)
        .subscribe()
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
  
  private func getTimerText(interval: TimeInterval) -> String {
    return DateManager.shared.elapsedTime(interval, format: .HHmmss)
  }
  
  func timerButtonTitle(isOn: Bool) -> String {
    return isOn
    ? Localization.walk_stop_button.localized
    : Localization.walk_start_button.localized
  }
  
  func requestImageForSimulator() -> Observable<Data> {
    
    let size = 5000
    let url = "https://picsum.photos/\(size)"
    
#if DEBUG
    LogManager.shared.log(with: "요청 URL : " + url, to: .local, level: .debug)
#endif
    
    return Observable.just(url)
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .compactMap { URL(string: $0) }
      .compactMap { try Data(contentsOf: $0) }
  }
}

// MARK: - Timer
extension WalkInProgressViewModel {
  struct BackgroundTimeIntervalManager {
    private var leaveTime: Date?
    
    mutating func logLeaveTime() {
      self.leaveTime = .now
    }
    
    mutating func backgroundTimeInterval() -> TimeInterval {
      guard let leaveTime else {
        return 0
      }
      
      let interval = Date.now.timeIntervalSince(leaveTime)
      self.leaveTime = nil
      
      return interval
    }
  }
  
  private func timerTick() {
    timeIntervalRelay.accept(timeIntervalRelay.value + 1)
  }
  
  private func logLeaveForegroundTime() {
    backgroundTimeIntervalManager.logLeaveTime()
  }
  
  private func addBackgroundTimeInterval() {
    let interval = backgroundTimeIntervalManager.backgroundTimeInterval()
    
    timeIntervalRelay.accept(timeIntervalRelay.value + interval)
  }
  
  private func clearTimer() {
    timer?.invalidate()
  }
  
  private func startTimer() {
    clearTimer()
    
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
      guard let self else { return }
      timerTick()
    }
  }
}
