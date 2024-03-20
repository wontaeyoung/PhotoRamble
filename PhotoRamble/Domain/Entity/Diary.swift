//
//  Diary.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation

struct Diary: Entity {
  
  enum WritingStatus: Int {
    case writing
    case done
    
    init(from rawValue: Int) {
      self = WritingStatus(rawValue: rawValue) ?? .writing
    }
  }
  
  let id: UUID
  var content: String
  let createAt: Date
  var updateAt: Date
  var writingStatus: WritingStatus
  var photoIndices: [Int]
  let walkID: UUID
  
  static func initialDiary(photoIndicies: [Int], walkID: UUID) -> Diary {
    return Diary(
      id: UUID(),
      content: "",
      createAt: .now,
      updateAt: .now, 
      writingStatus: .writing,
      photoIndices: photoIndicies,
      walkID: walkID
    )
  }
}
