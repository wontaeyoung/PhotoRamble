//
//  PostMapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import RealmSwift

struct PostMapper: Mapper {
  
  func toDTO(_ entity: Post) -> PostDTO{
    return PostDTO(
      id: entity.id,
      content: entity.content,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      writingStatus: entity.writingStatus.rawValue,
      photoIndices: entity.photoIndices.toList,
      walkID: entity.walkID
    )
  }
  
  func toEntity(_ dto: PostDTO) -> Post {
    return Post(
      id: dto.id,
      content: dto.content,
      createAt: dto.createAt,
      updateAt: dto.updateAt,
      writingStatus: .init(from: dto.writingStatus),
      photoIndices: dto.photoIndices.toArray,
      walkID: dto.walkID
    )
  }
}
