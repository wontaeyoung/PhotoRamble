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
    
    let service = LiveRealmService()
    let mapper = DiaryMapper()
    
    let appInfoRepository = AppInfoRepositoryImpl()
    let appPermissionRepository = AppPermissionRepositoryImpl()
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: mapper)
    
    let fetchAppVersionUsecase = FetchAppVersionUsecaseImpl(appInfoRepository: appInfoRepository)
    let canAccessCameraUsecase = CanAccessCameraUsecaseImpl(appPermissionRepository: appPermissionRepository)
    let deleteAllDiaryUsecase = DeleteAllDiaryUsecaseImpl(diaryRepository: diaryRepository)
    
    let viewModel = SettingViewModel(
      fetchAppVersionUsecase: fetchAppVersionUsecase,
      canAccessCameraUsecase: canAccessCameraUsecase,
      deleteAllDiaryUsecase: deleteAllDiaryUsecase
    )
      .coordinator(self)
    
    let viewController = SettingViewController(viewModel: viewModel)
      .hideBackTitle()
      .navigationTitle(with: Localization.tab_setting.localized, displayMode: .never)
    
    push(viewController)
  }
  
  func showSettingWebView(webCase: SettingWebCase) {
    
    let viewController = SettingWebViewController(webCase: webCase)
      .hideBackTitle()
      .navigationTitle(with: webCase.navigationTitle, displayMode: .never)
    
    push(viewController)
  }
}
