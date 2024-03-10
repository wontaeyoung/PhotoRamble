//
//  LocationMapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import RealmSwift

struct LocationMapper: Mapper {
  
  func toDTO(_ entity: Location) -> LocationDTO {
    return LocationDTO(
      id: entity.id,
      latitude: entity.latitude,
      longitude: entity.longitude,
      timestamp: entity.timestamp
    )
  }
  
  func toDTO(_ entities: [Location]) -> List<LocationDTO> {
    return entities
      .map { toDTO($0) }
      .toList
  }
  
  func toEntity(_ dto: LocationDTO) -> Location {
    return Location(
      id: dto.id,
      latitude: dto.latitude,
      longitude: dto.longitude,
      timestamp: dto.timestamp
    )
  }
  
  func toEntity(_ dtos: List<LocationDTO>) -> [Location] {
    return dtos
      .toArray
      .map { toEntity($0) }
  }
}
