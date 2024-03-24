//
//  SettingCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import UIKit
import RxRelay

final class SettingCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    
  }
}

extension SettingCoordinator {
  
}
