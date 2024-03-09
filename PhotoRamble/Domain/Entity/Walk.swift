//
//  Walk.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation

struct Walk: Entity {
  
  let id: UUID
  let startAt: Double
  let endAt: Double
  let locations: [Location]
  let postID: UUID?
}
