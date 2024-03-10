//
//  Mapper.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

protocol Mapper {
  associatedtype DTOType: DTO
  associatedtype EntityType: Entity
  
  func toDTO(_ entity: EntityType) -> DTOType
  func toEntity(_ dto: DTOType) -> EntityType
}
