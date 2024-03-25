//
//  MainTabBarCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit

protocol TabBarDelegate: AnyObject {
  func moveTab(to tab: MainTabBarPage)
}

extension MainTabBarCoordinator: TabBarDelegate {
  func moveTab(to tab: MainTabBarPage) {
    tabBarController.selectedIndex = tab.index
  }
}

final class MainTabBarCoordinator: Coordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  var tabBarController: UITabBarController
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
    self.tabBarController = UITabBarController()
  }
  
  // MARK: - Method
  func start() {
    let rootNavigationControllers = MainTabBarPage.allCases.map { page in
      makeNavigationController(with: page)
    }
    
    configureTabBarController(with: rootNavigationControllers)
    self.push(tabBarController)
  }
  
  private func configureTabBarController(with controllers: [UINavigationController]) {
    tabBarController.configure {
      $0.setViewControllers(controllers, animated: false)
      $0.selectedIndex = MainTabBarPage.walk.index
    }
  }
  
  private func makeNavigationController(with page: MainTabBarPage) -> UINavigationController {
    return UINavigationController().configured {
      $0.tabBarItem = page.tabBarItem
      connectTabFlow(page: page, tabPageController: $0)
    }
    .navigationLargeTitleEnabled()
  }
  
  private func connectTabFlow(page: MainTabBarPage, tabPageController: UINavigationController) {
    switch page {
      case .walk:
        let coordinator = WalkCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
        
      case .diary:
        let coordinator = DiaryCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
        
      case .setting:
        let coordinator = SettingCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
    }
  }
}
