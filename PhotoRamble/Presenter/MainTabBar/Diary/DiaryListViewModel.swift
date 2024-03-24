//
//  DiaryListViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DiaryListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let diaryCellTapEvent: PublishRelay<IndexPath>
  }
  
  struct Output {
    let diaries: Driver<[Diary]>
  }
  
  // MARK: - Observable
  private let diariesRelay = BehaviorRelay<[Diary]>(value: [])
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: DiaryCoordinator?
  private let fetchDiaryUsecase: any FetchDiaryUsecase
  private let fetchWalkUsecase: any FetchWalkUsecase
  
  // MARK: - Initializer
  init(
    fetchDiaryUsecase: some FetchDiaryUsecase,
    fetchWalkUsecase: some FetchWalkUsecase
  ) {
    self.fetchDiaryUsecase = fetchDiaryUsecase
    self.fetchWalkUsecase = fetchWalkUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchDiaryUsecase.execute()
          .asObservable()
      }
      .subscribe(with: self) { owner, diaries in
        owner.diariesRelay.accept(diaries)
      }
      .disposed(by: disposeBag)
    
    input.diaryCellTapEvent
      .map { self.diary(at: $0) }
      .withUnretained(self)
      .flatMap { owner, diary in
        return owner.fetchWalkUsecase.execute(walkID: diary.walkID)
          .asObservable()
          .map { ($0, diary) }
      }
      .subscribe(with: self) { owner, result in
        let (walk, diary) = result
        
        owner.coordinator?.showDiaryDetailView(diary: diary, walk: walk)
      } onError: { owner, error in
        LogManager.shared.log(with: error, to: .local)
        owner.coordinator?.showErrorAlert(error: error)
      }
      .disposed(by: disposeBag)

    BindingContainer.shared.diaryTableUpdatedEvent
      .bind(to: input.viewDidLoadEvent)
      .disposed(by: disposeBag)
    
    return Output(
      diaries: diariesRelay.asDriver()
    )
  }
  
  private func diary(at indexPath: IndexPath) -> Diary {
    return diariesRelay.value[indexPath.item]
  }
}
