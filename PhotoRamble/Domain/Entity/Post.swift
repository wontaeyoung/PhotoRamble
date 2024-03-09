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
  }
  
  let id: UUID
  let content: String
  let createAt: Date
  let updateAt: Date
  let writingStatus: WritingStatus
  let photoIndices: [Int]
  let walkID: UUID
}
