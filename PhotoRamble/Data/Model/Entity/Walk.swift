//
//  Walk.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation

struct Walk: Entity {
  
  typealias Second = Int
  
  // MARK: - Property
  let id: UUID
  let startAt: Date
  var endAt: Date?
  var locations: [Location]
  var walkDuration: Second
  var diaryID: UUID?
  
  // MARK: - Intializer
  /// 전달받은 인자들로 Walk 인스턴스를 생성합니다.
  init(id: UUID, startAt: Date, endAt: Date?, locations: [Location], walkDuration: Second, diaryID: UUID?) {
    self.id = id
    self.startAt = startAt
    self.endAt = endAt
    self.locations = locations
    self.walkDuration = walkDuration
    self.diaryID = diaryID
  }
  
  /// 초기값을 가진 Walk 인스턴스를 생성합니다.
  init() {
    self.id = UUID()
    self.startAt = .now
    self.endAt = nil
    self.locations = []
    self.walkDuration = 0
    self.diaryID = nil
  }
}
