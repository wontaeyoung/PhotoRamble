//
//  CreateDiaryUsecaseImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import Foundation
import RxSwift

final class CreateDiaryUsecaseImpl: CreateDiaryUsecase {
  
  // MARK: - Property
  private let diaryRepository: any DiaryRepository
  
  // MARK: - Initializer
  init(diaryRepository: some DiaryRepository) {
    self.diaryRepository = diaryRepository
  }
  
  // MARK: - Method
  func execute(with diary: Diary) -> Single<Diary> {
    return diaryRepository.create(with: diary)
  }
}
