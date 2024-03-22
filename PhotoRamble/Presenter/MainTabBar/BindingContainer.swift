//
//  BindingContainer.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/23/24.
//

import RxSwift
import RxRelay
import KazRealm

final class BindingContainer {
  
  static let shared: BindingContainer = BindingContainer()
  
  private init() {
    
    let repository = DiaryRepositoryImpl(service: LiveRealmService(), mapper: DiaryMapper())
    let fetchDiaryUsecase = FetchDiaryUsecaseImpl(diaryRepository: repository)
    
    fetchDiaryUsecase.execute()
      .subscribe(with: self, onSuccess: { owner, diaries in
        owner.diaries.accept(diaries)
      })
      .disposed(by: disposeBag)
  }
  
  private var disposeBag: DisposeBag = DisposeBag()
  
  let diaries = BehaviorRelay<[Diary]>(value: [])
}
