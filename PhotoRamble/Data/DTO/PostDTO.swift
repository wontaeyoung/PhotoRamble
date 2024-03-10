//
//  PostDTO.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation
import KazRealm
import RealmSwift

final class PostDTO: Object, RealmModel, DTO {
  
  enum Column: String {
    
    case id
    case content
    case createAt
    case updateAt
    case writingStatus
    case photoIndices
    case walkID
  }
  
  @Persisted(primaryKey: true) var id: UUID
  @Persisted var content: String
  @Persisted var createAt: Date
  @Persisted var updateAt: Date
  @Persisted var writingStatus: Int
  @Persisted var photoIndices: List<Int>
  @Persisted var walkID: UUID
  
  init(id: UUID, content: String, createAt: Date, updateAt: Date, writingStatus: Int, photoIndices: List<Int>, walkID: UUID) {
    super.init()
    
    self.id = id
    self.content = content
    self.createAt = createAt
    self.updateAt = updateAt
    self.writingStatus = writingStatus
    self.photoIndices = photoIndices
    self.walkID = walkID
  }
}
