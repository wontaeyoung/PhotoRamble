//
//  UIAlertController+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

internal extension UIAlertController {
  func addActions(_ actions: UIAlertAction...) {
    actions.forEach { self.addAction($0) }
  }
  
  func setAction(
    title: String?,
    style: UIAlertAction.Style,
    completion: (() -> Void)? = nil
  ) -> UIAlertController {
    let alertAction = UIAlertAction(title: title, style: style) { _ in
      completion?()
    }
    
    addAction(alertAction)
    
    return self
  }
  
  func setCancelAction() -> UIAlertController {
    
    return setAction(title: "취소", style: .cancel)
  }
}

