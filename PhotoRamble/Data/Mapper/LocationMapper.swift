//
//  LocationMapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation
import RealmSwift

struct LocationMapper: Mapper {
  
  static func toDTO(_ entity: Location) throws -> LocationDTO {
    return LocationDTO(
      id: try ObjectId(string: entity.id.uuidString),
      latitude: entity.latitude,
      longitude: entity.longitude,
      timestamp: entity.timestamp
    )
  }
  
  static func toEntity(_ dto: LocationDTO) throws -> Location {
    return Location(
      id: try UUID.from(string: dto.id.stringValue),
      latitude: dto.latitude,
      longitude: dto.longitude,
      timestamp: dto.timestamp
    )
  }
}
