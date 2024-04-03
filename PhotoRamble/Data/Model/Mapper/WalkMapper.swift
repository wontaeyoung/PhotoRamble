//
//  WalkMapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import RealmSwift

struct WalkMapper: Mapper {
  
  private let locationMapper: LocationMapper
  
  init(locationMapper: LocationMapper) {
    self.locationMapper = locationMapper
  }
  
  func toDTO(_ entity: Walk) -> WalkDTO {
    return WalkDTO(
      id: entity.id,
      startAt: entity.startAt,
      endAt: entity.endAt,
      walkDuration: entity.walkDuration,
      locations: locationMapper.toDTO(entity.locations),
      diaryID: entity.diaryID
    )
  }
  
  func toEntity(_ dto: WalkDTO) -> Walk {
    return Walk(
      id: dto.id,
      startAt: dto.startAt,
      endAt: dto.endAt,
      locations: locationMapper.toEntity(dto.locations),
      walkDuration: dto.walkDuration,
      diaryID: dto.diaryID
    )
  }
}
