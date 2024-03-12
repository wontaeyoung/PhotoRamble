//
//  WalkInProgressViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import KazUtility
import RxSwift
import RxCocoa

final class WalkInProgressViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let takenNewPhotoDataEvent: PublishRelay<Data>
    let timerToggleEvent: PublishRelay<Void>
  }
  
  struct Output {
    let imageDataUpdated: RxSwift.Observable<[Data]>
    let timerText: RxSwift.Observable<String>
  }
  
  // MARK: - Observable
  private var walkRelay = BehaviorRelay<Walk>(value: Walk())
  private let imagesDataRelay = BehaviorRelay<[Data]>(value: [])
  private let timerStateRelay = BehaviorRelay<Bool>(value: false)
  
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
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
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
    
    return Output(
      imageDataUpdated: imagesDataRelay.asObservable()
    )
  }
  
  private func updateImageDataList(with newData: Data) {
    var currentList = imagesDataRelay.value
    currentList.append(newData)
    
    imagesDataRelay.accept(currentList)
  }
}
