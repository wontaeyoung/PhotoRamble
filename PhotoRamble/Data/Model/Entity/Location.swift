//
//  Location.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation

struct Location: Entity {
  
  let id: UUID
  let latitude: Double
  let longitude: Double
  let timestamp: Date
}
