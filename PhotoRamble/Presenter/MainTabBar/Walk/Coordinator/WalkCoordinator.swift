//
//  WalkCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import KazUtility

final class WalkCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showWalkView()
  }
}

extension WalkCoordinator {
  
  func showWalkView() {
    let viewModel = WalkViewModel()
    let viewController = WalkViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.walk.navigationTitle, displayMode: .never)
      .hideBackTitle()
    viewModel.coordinator = self
    
    push(viewController)
  }
  
  func showWalkInProgressView() {
    
  }
}
