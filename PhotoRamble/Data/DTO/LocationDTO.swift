//
//  LocationDTO.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation
import KazRealm
import RealmSwift

final class LocationDTO: Object, RealmModel, DTO {
  
  enum Column: String {
    
    case id
    case latitude
    case longitude
    case timestamp
  }
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var latitude: Double
  @Persisted var longitude: Double
  @Persisted var timestamp: Date
  
  init(id: ObjectId, latitude: Double, longitude: Double, timestamp: Date) {
    super.init()
    
    self.id = id
    self.latitude = latitude
    self.longitude = longitude
    self.timestamp = timestamp
  }
}
