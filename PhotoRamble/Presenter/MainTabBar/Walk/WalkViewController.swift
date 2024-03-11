//
//  WalkViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WalkViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let goWalkButton = PRButton(style: .primary, title: Localization.walk_go_button.localized)
  
  // MARK: - Property
  let viewModel: WalkViewModel
  
  // MARK: - Initializer
  init(viewModel: WalkViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(goWalkButton)
  }
  
  override func setConstraint() {
    goWalkButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    let input = WalkViewModel.Input(
      walkButtonTapEvent: PublishRelay<Void>()
    )
    
    goWalkButton.rx.tap
      .bind(to: input.walkButtonTapEvent)
      .disposed(by: disposeBag)
    
    viewModel.transform(input: input)
  }
}
