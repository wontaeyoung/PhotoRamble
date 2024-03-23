//
//  DiaryListViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import RxSwift
import RxCocoa

final class DiaryListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
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
  
  // MARK: - Initializer
  init(fetchDiaryUsecase: some FetchDiaryUsecase) {
    self.fetchDiaryUsecase = fetchDiaryUsecase
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
    
    BindingContainer.shared.diaryTableUpdatedEvent
      .bind(to: input.viewDidLoadEvent)
      .disposed(by: disposeBag)
    
    return Output(
      diaries: diariesRelay.asDriver()
    )
  }
}
