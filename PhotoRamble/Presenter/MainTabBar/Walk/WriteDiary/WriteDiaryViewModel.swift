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
    
    var navigationTitle: String {
      switch self {
        case .initial:
          return "일기 쓰기"
          
        case .modify:
          return "일기 다시쓰기"
      }
    }
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
    let showCreatedDiaryToast: Signal<Void>
  }
  
  // MARK: - Observable
  private let walkRelay: BehaviorRelay<Walk>
  private let diaryRelay: BehaviorRelay<Diary>
  private let contentRelay: BehaviorRelay<String>
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  private let imageRepository: any ImageRepository
  private let diaryRepository: any DiaryRepository
  
  private var currentWalk: Walk {
    return walkRelay.value
  }
  
  private var currentDiary: Diary {
    return diaryRelay.value
  }
  
  private var photoDirectoryName: String {
    return currentWalk.id.uuidString
  }
  
  // MARK: - Initializer
  init(
    style: WritingStyle,
    walk: Walk,
    diary: Diary,
    imageRepository: some ImageRepository,
    diaryRepository: some DiaryRepository
  ) {
    self.walkRelay = .init(value: walk)
    self.diaryRelay = .init(value: diary)
    self.contentRelay = .init(value: diary.content)
    self.imageRepository = imageRepository
    self.diaryRepository = diaryRepository
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let dateText: Signal<String> = Observable.just(walkDateString(date: walkRelay.value.startAt))
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
      .withUnretained(self)
      .flatMap { owner, index in
        let fileIndex = owner.removedFileIndex(at: index)
        owner.imageRepository.delete(directoryName: owner.photoDirectoryName, fileIndex: fileIndex)
        
        return Observable.just(index)
      }
      .bind(with: self) { owner, index in
        owner.deletePhotoIndex(at: index)
        deleteCompleted.accept(index)
      }
      .disposed(by: disposeBag)
    
    input.writingCompletedButtonTapEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.prepareEntitiesForNextFlow()
        
        return owner.diaryRepository.create(with: owner.currentDiary)
      }
      .subscribe(with: self, onNext: { owner, diary in
        showCreatedDiaryToast.accept(())
        BindingContainer.shared.diaryTableUpdatedEvent.accept(())
      }, onError: { owner, error in
        // FIXME: 실패 알럿 띄우기 전에 인디케이터 종료를 위한 output 이벤트 방출해야함
        LogManager.shared.log(with: error, to: .local)
        owner.coordinator?.showErrorAlert(error: error)
      })
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
      showCreatedDiaryToast: showCreatedDiaryToast.asSignal()
    )
  }
  
  private func walkDateString(date: Date) -> String {
    return DateManager.shared.toString(with: date, format: .yyyyMMddEEEEKR)
  }
  
  private func walkTimeString(duration: Int) -> String {
    return DateManager.shared.elapsedTime(duration, format: .HHmmssKR)
  }
  
  private func removedFileIndex(at index: Int) -> Int {
    return diaryRelay.value.photoIndices[index]
  }
  
  private func deletePhotoIndex(at index: Int) {
    let updatedDiary = diaryRelay.value.applied {
      $0.photoIndices = $0.photoIndices.removed(at: index)
    }
    
    diaryRelay.accept(updatedDiary)
  }
  
  private func prepareEntitiesForNextFlow() {
    let updatedDiary = diaryRelay.value.applied {
      $0.writingStatus = .done
      $0.content = contentRelay.value
    }
    
    diaryRelay.accept(updatedDiary)
  }
}
