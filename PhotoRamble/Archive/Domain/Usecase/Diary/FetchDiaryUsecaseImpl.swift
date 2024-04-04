//
//  FetchDiaryUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import RxSwift

final class FetchDiaryUsecaseImpl: FetchDiaryUsecase {
  
  // MARK: - Property
  private let diaryRepository: any DiaryRepository
  
  // MARK: - Initializer
  init(diaryRepository: some DiaryRepository) {
    self.diaryRepository = diaryRepository
  }
  
  // MARK: - Method
  func execute() -> Single<[Diary]> {
    return diaryRepository.fetch()
  }
}
