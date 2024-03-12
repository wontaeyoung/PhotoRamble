//
//  UIView+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

public extension UIView {
  func addSubviews(_ view: UIView...) {
    view.forEach { self.addSubview($0) }
  }
}
