//
//  WalkDTO.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation
import KazRealm
import RealmSwift

final class WalkDTO: Object, RealmModel, DTO {
  
  enum Column: String {
    
    case id
    case startAt
    case endAt
    case locations
    case diaryID
  }
  
  @Persisted(primaryKey: true) var id: UUID
  @Persisted var startAt: Date
  @Persisted var endAt: Date?
  @Persisted var locations: List<LocationDTO>
  @Persisted var walkDuration: Int
  @Persisted var diaryID: UUID?
  
  convenience init(id: UUID, startAt: Date, endAt: Date?, walkDuration: Int, locations: List<LocationDTO>, diaryID: UUID?) {
    self.init()
    
    self.id = id
    self.startAt = startAt
    self.endAt = endAt
    self.walkDuration = walkDuration
    self.locations = locations
    self.diaryID = diaryID
  }
}
