//
//  WalkMapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import RealmSwift

struct WalkMapper: Mapper {
  
  static func toDTO(_ entity: Walk) -> WalkDTO {
    return WalkDTO(
      id: entity.id,
      startAt: entity.startAt,
      endAt: entity.endAt,
      locations: LocationMapper.toDTO(entity.locations),
      postID: entity.postID
    )
  }
  
  static func toEntity(_ dto: WalkDTO) -> Walk {
    return Walk(
      id: dto.id,
      startAt: dto.startAt,
      endAt: dto.endAt,
      locations: LocationMapper.toEntity(dto.locations),
      postID: dto.postID
    )
  }
}
