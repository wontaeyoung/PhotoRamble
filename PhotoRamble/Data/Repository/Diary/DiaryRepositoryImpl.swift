//
//  DiaryRepositoryImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import Foundation
import KazRealm
import RxSwift

final class DiaryRepositoryImpl: DiaryRepository {
  
  private let service: any RealmService
  private let mapper: DiaryMapper
  
  init(service: RealmService, mapper: DiaryMapper) {
    self.service = service
    self.mapper = mapper
  }
  
  func create(with diary: Diary) -> Single<Diary> {
    
    let diaryDTO = mapper.toDTO(diary)
    
    do {
      try service.create(with: diaryDTO)
      return .just(diary)
    } catch {
      return .error(PRError.RealmRepository.createFailed(error: error, modelName: "일기"))
    }
  }
  
  func fetch() -> Single<[Diary]> {
     
    let diaryDTOs: [DiaryDTO] = service.fetch()
      .sorted(byKeyPath: DiaryDTO.Column.createAt.rawValue, ascending: false)
      .toList()
      .toArray
    
    let diaries: [Diary] = mapper.toEntity(diaryDTOs)
    
    return .just(diaries)
  }
}
