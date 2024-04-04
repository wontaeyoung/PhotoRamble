//
//  DiaryMapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import RealmSwift

struct DiaryMapper: Mapper {
  
  func toDTO(_ entity: Diary) -> DiaryDTO{
    return DiaryDTO(
      id: entity.id,
      content: entity.content,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      writingStatus: entity.writingStatus.rawValue,
      photoIndices: entity.photoIndices.toList,
      walkID: entity.walkID
    )
  }
  
  func toEntity(_ dto: DiaryDTO) -> Diary {
    return Diary(
      id: dto.id,
      content: dto.content,
      createAt: dto.createAt,
      updateAt: dto.updateAt,
      writingStatus: .init(from: dto.writingStatus),
      photoIndices: dto.photoIndices.toArray,
      walkID: dto.walkID
    )
  }
  
  func toEntity(_ dtos: [DiaryDTO]) -> [Diary] {
    return dtos
      .map { toEntity($0) }
  }
}
