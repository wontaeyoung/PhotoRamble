//
//  SplashCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/29/24.
//

import UIKit

final class SplashCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showSplashView()
  }
}

extension SplashCoordinator {
  
  func showSplashView() {
    let appInfoRepository = AppInfoRepositoryImpl()
    let viewModel = SplashViewModel(appInfoRepository: appInfoRepository)
      .coordinator(self)
    
    let viewController = SplashViewController(viewModel: viewModel)
      .hideBackButton()
    
    push(viewController, animation: false)
  }
  
  func connectMainTabBarFlow() {
    let mainTabBarCoordinator = MainTabBarCoordinator(self.navigationController)
    mainTabBarCoordinator.start()
    self.addChild(mainTabBarCoordinator)
  }
}
