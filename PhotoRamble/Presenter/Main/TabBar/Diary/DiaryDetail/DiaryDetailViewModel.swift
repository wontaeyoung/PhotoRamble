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
  private let imageRepository: any ImageRepository
  
  var numberOfItems: Int {
    return imageDataList.value.count
  }
  
  private var currentWalk: Walk {
    return walk.value
  }
  
  private var photoDirectoryName: String {
    return currentWalk.id.uuidString
  }
  
  // MARK: - Initializer
  init(diary: Diary, walk: Walk, imageRepository: some ImageRepository) {
    self.imageDataList = .init(value: [])
    self.diary = .init(value: diary)
    self.walk = .init(value: walk)
    self.imageRepository = imageRepository
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    imageRepository.fetch(directoryName: photoDirectoryName)
      .asDriver(onErrorJustReturn: [])
      .drive(imageDataList)
      .disposed(by: disposeBag)
    
    let dateText = Observable.just(walkDateString(date: currentWalk.startAt))
      .asDriver(onErrorJustReturn: "-")
    
    let walkTimeText = Observable.just(walkTimeString(duration: currentWalk.walkDuration))
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
