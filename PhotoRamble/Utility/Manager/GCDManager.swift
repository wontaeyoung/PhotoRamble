//
//  GCDManager.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import Foundation

public final class GCD {
  public static func main(work: @escaping () -> Void) {
    DispatchQueue.main.async {
      work()
    }
  }
  
  public static func global(work: @escaping () -> Void) {
    DispatchQueue.global().async {
      work()
    }
  }
  
  public static func main(after time: Double, work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
      work()
    }
  }
  
  public static func global(after time: Double, work: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + time) {
      work()
    }
  }
}
