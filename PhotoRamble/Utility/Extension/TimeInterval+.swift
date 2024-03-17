//
//  TimeInterval+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/17/24.
//

import Foundation

extension TimeInterval {
  
  var toTimeFormatString: String {
    return DateManager.shared.elapsedTime(self, format: .HHmmssKR)
  }
}
