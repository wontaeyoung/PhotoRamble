//
//  WriteDiaryViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WriteDiaryViewModel: ViewModel {
  
  enum WritingStyle {
    case initial(distance: Double, interval: TimeInterval)
    case modify(date: Date, temperature: Int, distance: Double, interval: TimeInterval)
  }
  
  // MARK: - I / O
  struct Input {
    let diaryText: PublishSubject<String>
    let writingCompletedButtonTapEvent: PublishRelay<(diaryText: String, photoIndices: [Int])>
  }
  
  struct Output {
    let dateText: Signal<String>
    let walkTimeInterval: Signal<String>
    let isCompleteButtonEnabled: Signal<Bool>
  }
  
  // MARK: - Observable
  private let walkRelay: BehaviorRelay<Walk>
  private let diaryRelay: BehaviorRelay<Diary>
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  
  // MARK: - Initializer
  init(style: WritingStyle, walk: Walk, diary: Diary) {
    self.walkRelay = .init(value: walk)
    self.diaryRelay = .init(value: diary)
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
      
    let dateText: Signal<String> = Observable.just(DateManager.shared.toString(with: diaryRelay.value.createAt, format: .yyyyMMddEEEEKR))
      .asSignal(onErrorJustReturn: "-")
    
    let walkTimeInterval: Signal<String> = Observable.just(DateManager.shared.toString(with: walkRelay.value.walkDuration, format: .HHmmssKR))
      .asSignal(onErrorJustReturn: DateManager.shared.toString(with: 0, format: .HHmmssKR))
    
    let isCompleteButtonEnabled: Signal<Bool> = input.diaryText
      .map { !$0.isEmpty }
      .asSignal(onErrorJustReturn: false)
    
    return Output(
      dateText: dateText,
      walkTimeInterval: walkTimeInterval,
      isCompleteButtonEnabled: isCompleteButtonEnabled
    )
  }
}
