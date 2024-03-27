//
//  UIViewController+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

internal extension UIViewController {
  func hideBackTitle() -> Self {
    self.navigationItem.backButtonTitle = ""
    return self
  }
  
  func navigationTitle(with title: String, displayMode: UINavigationItem.LargeTitleDisplayMode) -> Self {
    self.navigationItem.title = title
    self.navigationItem.largeTitleDisplayMode = displayMode
    return self
  }
  
  func hideTabBar() -> Self {
    self.hidesBottomBarWhenPushed = true
    return self
  }
  
  func hideBackButton() -> Self {
    self.navigationItem.setHidesBackButton(true, animated: false)
    return self
  }
}
