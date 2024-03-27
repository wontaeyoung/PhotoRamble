//
//  UINavigationController+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

internal extension UINavigationController {
  
  func navigationLargeTitleEnabled() -> Self {
    self.navigationBar.prefersLargeTitles = true
    
    return self
  }
  
  func navigationBarHidden() -> Self {
    self.setNavigationBarHidden(true, animated: false)
    
    return self
  }
}
