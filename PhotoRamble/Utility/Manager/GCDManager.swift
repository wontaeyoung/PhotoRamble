//
//  GCDManager.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import Foundation

internal final class GCD {
  internal static func main(work: @escaping () -> Void) {
    DispatchQueue.main.async {
      work()
    }
  }
  
  internal static func global(work: @escaping () -> Void) {
    DispatchQueue.global().async {
      work()
    }
  }
  
  internal static func main(after time: Double, work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
      work()
    }
  }
  
  internal static func global(after time: Double, work: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + time) {
      work()
    }
  }
}
