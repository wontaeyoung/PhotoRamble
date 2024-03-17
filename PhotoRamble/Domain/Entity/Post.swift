//
//  Post.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation

struct Post: Entity {
  
  enum WritingStatus: Int {
    case choosePhoto
    case writing
    case done
    
    init(from rawValue: Int) {
      self = WritingStatus(rawValue: rawValue) ?? .choosePhoto
    }
  }
  
  let id: UUID
  let content: String
  let createAt: Date
  var updateAt: Date
  var writingStatus: WritingStatus
  let photoIndices: [Int]
  let walkID: UUID
}
