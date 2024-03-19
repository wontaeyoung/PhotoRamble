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
    case initial
    case modify(diary: Diary)
  }
  
  // MARK: - I / O
  struct Input {
    let diaryText: PublishRelay<String>
    let photoDeletedEvent: PublishRelay<Int>
    let writingCompletedButtonTapEvent: PublishRelay<Void>
    let cratedDiaryToastCompletedEvent: PublishRelay<Void>
  }
  
  struct Output {
    let dateText: Signal<String>
    let walkTimeInterval: Signal<String>
    let deleteCompleted: Signal<Int>
    let isCompleteButtonEnabled: Signal<Bool>
    let showCretedDiaryToast: Signal<Void>
  }
  
  // MARK: - Observable
  private let walkRelay: BehaviorRelay<Walk>
  private let diaryRelay: BehaviorRelay<Diary>
  private let contentRelay: BehaviorRelay<String>
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  
  // MARK: - Initializer
  init(style: WritingStyle, walk: Walk, diary: Diary) {
    self.walkRelay = .init(value: walk)
    self.diaryRelay = .init(value: diary)
    self.contentRelay = .init(value: "")
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let dateText: Signal<String> = Observable.just(diaryDateString(date: diaryRelay.value.createAt))
      .asSignal(onErrorJustReturn: "-")
    
    let walkTimeInterval: Signal<String> = Observable.just(walkTimeString(duration: walkRelay.value.walkDuration))
      .asSignal(onErrorJustReturn: DateManager.shared.toString(with: 0, format: .HHmmssKR))
    
    let deleteCompleted = PublishRelay<Int>()
    
    let isCompleteButtonEnabled: Signal<Bool> = contentRelay
      .map { !$0.isEmpty }
      .asSignal(onErrorJustReturn: false)
    
    let showCreatedDiaryToast = PublishRelay<Void>()
    
    input.diaryText
      .bind(to: contentRelay)
      .disposed(by: disposeBag)
    
    input.photoDeletedEvent
      .bind(with: self) { owner, index in
        owner.deletePhotoIndex(at: index)
        deleteCompleted.accept(index)
      }
      .disposed(by: disposeBag)
    
    input.writingCompletedButtonTapEvent
      .bind(with: self) { owner, _ in
        showCreatedDiaryToast.accept(())
      }
      .disposed(by: disposeBag)
    
    input.cratedDiaryToastCompletedEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.popToRoot()
      }
      .disposed(by: disposeBag)
    
    return Output(
      dateText: dateText,
      walkTimeInterval: walkTimeInterval,
      deleteCompleted: deleteCompleted.asSignal(),
      isCompleteButtonEnabled: isCompleteButtonEnabled,
      showCretedDiaryToast: showCreatedDiaryToast.asSignal()
    )
  }
  
  private func diaryDateString(date: Date) -> String {
    return DateManager.shared.toString(with: date, format: .yyyyMMddEEEEKR)
  }
  
  private func walkTimeString(duration: Int) -> String {
    return DateManager.shared.elapsedTime(duration, format: .HHmmssKR)
  }
  
  private func deletePhotoIndex(at index: Int) {
    let updatedDiary = diaryRelay.value.applied {
      $0.photoIndices = $0.photoIndices.removed(at: index)
    }
    
    diaryRelay.accept(updatedDiary)
  }
}
