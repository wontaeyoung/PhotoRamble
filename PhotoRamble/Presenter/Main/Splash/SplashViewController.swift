//
//  SplashViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SplashViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let appNameLabel = PRLabel(style: .appName, title: Localization.app_logo_name.localized, alignment: .center)
  
  // MARK: - Property
  let viewModel: SplashViewModel
  
  // MARK: - Initializer
  init(viewModel: SplashViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(appNameLabel)
  }
  
  override func setConstraint() {
    appNameLabel.snp.makeConstraints { make in
      make.center.equalTo(view)
    }
  }
  
  override func setAttribute() {
    view.backgroundColor = PRAsset.Color.prPrimary
  }
  
  override func bind() {
    
    let input = SplashViewModel.Input()
    let output = viewModel.transform(input: input)
    
    input.viewDidLoadEvent.accept(())
  }
  
  // MARK: - Method
  
}
