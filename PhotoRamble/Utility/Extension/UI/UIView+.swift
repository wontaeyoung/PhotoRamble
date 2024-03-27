//
//  UIView+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

internal extension UIView {
  func addSubviews(_ view: UIView...) {
    view.forEach { self.addSubview($0) }
  }
}
