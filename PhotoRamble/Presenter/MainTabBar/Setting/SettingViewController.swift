//
//  SettingViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: SettingViewModel
  
  // MARK: - Initializer
  init(viewModel: SettingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
  }
  
  override func setConstraint() {
    
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
  }
  
  // MARK: - Method
  
}
