//
//  DiaryDetailViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/24/24.
//

import RxSwift
import RxCocoa
import Foundation

final class DiaryDetailViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    let dateText: Driver<String>
    let walkTimeText: Driver<String>
    let contentText: Driver<String>
    let imageDataList: Driver<[Data]>
  }
  
  // MARK: - Observable
  private let diary: BehaviorRelay<Diary>
  private let walk: BehaviorRelay<Walk>
  private let imageDataList: BehaviorRelay<[Data]>
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: DiaryCoordinator?
  private let fetchImageUsecase: any FetchImageFileUsecase
  
  var numberOfItems: Int {
    return imageDataList.value.count
  }
  
  // MARK: - Initializer
  init(diary: Diary, walk: Walk, fetchImageUsecase: some FetchImageFileUsecase) {
    self.imageDataList = BehaviorRelay(value: [])
    self.diary = BehaviorRelay(value: diary)
    self.walk = BehaviorRelay(value: walk)
    self.fetchImageUsecase = fetchImageUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    fetchImageUsecase.execute(directoryName: walk.value.id.uuidString)
      .asDriver(onErrorJustReturn: [])
      .drive(imageDataList)
      .disposed(by: disposeBag)
    
    let dateText = Observable.just(walkDateString(date: walk.value.startAt))
      .asDriver(onErrorJustReturn: "-")
    
    let walkTimeText = Observable.just(walkTimeString(duration: walk.value.walkDuration))
      .asDriver(onErrorJustReturn: DateManager.shared.elapsedTime(0, format: .HHmmssKR))
    
    let contentText = Observable.just(diary.value.content)
      .asDriver(onErrorJustReturn: "")
    
    return Output(
      dateText: dateText,
      walkTimeText: walkTimeText,
      contentText: contentText,
      imageDataList: imageDataList.asDriver()
    )
  }
  
  private func walkDateString(date: Date) -> String {
    return DateManager.shared.toString(with: date, format: .yyyyMMddEEEEKR)
  }
  
  private func walkTimeString(duration: Int) -> String {
    return DateManager.shared.elapsedTime(duration, format: .HHmmssKR)
  }
}
