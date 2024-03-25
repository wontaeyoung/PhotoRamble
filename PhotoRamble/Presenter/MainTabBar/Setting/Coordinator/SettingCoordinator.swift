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
    showSettingView()
  }
}

extension SettingCoordinator {
  
  func showSettingView() {
    
    let appInfoRepository = AppInfoRepositoryImpl()
    let fetchAppVersionUsecase = FetchAppVersionUsecaseImpl(appInfoRepository: appInfoRepository)
    
    let viewModel = SettingViewModel(fetchAppVersionUsecase: fetchAppVersionUsecase)
      .coordinator(self)
    
    let viewController = SettingViewController(viewModel: viewModel)
      .hideBackTitle()
      .navigationTitle(with: Localization.tab_setting.localized, displayMode: .never)
    
    push(viewController)
  }
}
