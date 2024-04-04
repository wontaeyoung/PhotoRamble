//
//  DeleteAllDiaryUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/26/24.
//

import RxSwift

final class DeleteAllDiaryUsecaseImpl: DeleteAllDiaryUsecase {
  
  // MARK: - Property
  private let diaryRepository: any DiaryRepository
  
  // MARK: - Initializer
  init(diaryRepository: some DiaryRepository) {
    self.diaryRepository = diaryRepository
  }
  
  // MARK: - Method
  func execute() -> Single<[Diary]> {
    return diaryRepository.deleteAll()
  }
}
