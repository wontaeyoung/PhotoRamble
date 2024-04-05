//
//  StartWalkSplashViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/4/24.
//

import UIKit
import SnapKit
import Lottie
import RxSwift
import RxCocoa

final class StartWalkSplashViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let splashView = LottieAnimationView(name: Constant.FileName.startWalkLottieJson).configured {
    $0.contentMode = .scaleAspectFit
    $0.loopMode = .playOnce
  }
  
  private let startWalkInfoLabel = PRLabel(style: .primaryInfo, title: "산책이 곧 시작돼요!", alignment: .center)
  
  // MARK: - Property
  let viewModel: StartWalkSplashViewModel
  
  // MARK: - Initializer
  init(viewModel: StartWalkSplashViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func loadView() {
    self.view = splashView
  }
  
  override func setHierarchy() {
    view.addSubview(startWalkInfoLabel)
  }
  
  override func setConstraint() {
    startWalkInfoLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
    }
  }
  
  override func bind() {
    let input = StartWalkSplashViewModel.Input(animationCompleteEvent: .init())
    let output = viewModel.transform(input: input)
    
    splashView.play { _ in
      input.animationCompleteEvent.accept(())
    }
  }
}
