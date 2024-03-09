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
    case postID
  }
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var startAt: Double
  @Persisted var endAt: Double
  @Persisted var locations: List<LocationDTO>
  @Persisted var postID: ObjectId?
  
  init(id: ObjectId, startAt: Double, endAt: Double, locations: List<LocationDTO>, postID: ObjectId?) {
    super.init()
    
    self.id = id
    self.startAt = startAt
    self.endAt = endAt
    self.locations = locations
    self.postID = postID
  }
}
