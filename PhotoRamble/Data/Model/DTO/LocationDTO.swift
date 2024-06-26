//
//  LocationDTO.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation
import RealmSwift

final class LocationDTO: Object, RealmModel, DTO {
  
  enum Column: String {
    
    case id
    case latitude
    case longitude
    case timestamp
  }
  
  @Persisted(primaryKey: true) var id: UUID
  @Persisted var latitude: Double
  @Persisted var longitude: Double
  @Persisted var timestamp: Date
  
  convenience init(id: UUID, latitude: Double, longitude: Double, timestamp: Date) {
    self.init()
    
    self.id = id
    self.latitude = latitude
    self.longitude = longitude
    self.timestamp = timestamp
  }
}
