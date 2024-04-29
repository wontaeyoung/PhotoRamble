//
//  AppCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit

final class AppCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    connectSplashFlow()
  }
}

extension AppCoordinator {
  
  private func connectSplashFlow() {
    let splashCoordinator = SplashCoordinator(self.navigationController)
    splashCoordinator.start()
    self.addChild(splashCoordinator)
  }
  
  private func connectMainTabBarFlow() {
    let mainTabBarCoordinator = MainTabBarCoordinator(self.navigationController)
    mainTabBarCoordinator.delegate = self
    mainTabBarCoordinator.start()
    self.addChild(mainTabBarCoordinator)
  }
}

extension AppCoordinator: CoordinatorDelegate {
  func coordinatorDidEnd(_ childCoordinator: Coordinator) { }
}

