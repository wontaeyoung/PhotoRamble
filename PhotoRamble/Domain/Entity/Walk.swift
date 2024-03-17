//
//  Walk.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/9/24.
//

import Foundation

struct Walk: Entity {
  
  // MARK: - Property
  let id: UUID
  let startAt: Date
  var endAt: Date?
  let locations: [Location]
  let diaryID: UUID?
  
  // MARK: - Intializer
  /// 전달받은 인자들로 Walk 인스턴스를 생성합니다.
  init(id: UUID, startAt: Date, endAt: Date?, locations: [Location], diaryID: UUID?) {
    self.id = id
    self.startAt = startAt
    self.endAt = endAt
    self.locations = locations
    self.diaryID = diaryID
  }
  
  /// 초기값을 가진 Walk 인스턴스를 생성합니다.
  init() {
    self.id = UUID()
    self.startAt = .now
    self.endAt = nil
    self.locations = []
    self.diaryID = nil
  }
}
