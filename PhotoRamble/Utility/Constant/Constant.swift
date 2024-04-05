//
//  Constant.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

enum Constant {
  static let timerStartText: String = "00:00:00"
  
  enum InfoKey {
    static let versionString: String = "CFBundleShortVersionString"
  }
  
  enum RegPattern {
    static let appVersion: String = #"^\d+\.\d+\.\d+$"#
  }
  
  enum FileName {
    static let startWalkLottieJson: String = "StartWalkSplash"
  }
}
