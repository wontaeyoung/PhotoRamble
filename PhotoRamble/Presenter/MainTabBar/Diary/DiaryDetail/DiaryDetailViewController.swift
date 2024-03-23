//
//  DiaryDetailViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DiaryDetailViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: DiaryDetailViewModel
  
  // MARK: - Initializer
  init(viewModel: DiaryDetailViewModel) {
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
}
