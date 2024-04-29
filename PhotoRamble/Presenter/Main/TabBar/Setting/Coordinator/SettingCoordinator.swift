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
    let appPermissionRepository = AppPermissionRepositoryImpl()
    let appInfoRepository = AppInfoRepositoryImpl()
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: mapper)
    
    let viewModel = SettingViewModel(
      appPermissionRepository: appPermissionRepository,
      appInfoRepository: appInfoRepository,
      diaryRepository: diaryRepository
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
  
  func moveToSetting() {
    
    showAlert(
      title: "권한 설정 안내",
      message: "카메라 권한은 [설정 > 산책일기]에서 변경 가능합니다. 설정으로 이동할까요?",
      okTitle: "설정으로 이동하기",
      isCancelable: true
    ) {
      guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
      
      if UIApplication.shared.canOpenURL(settingURL) {
        UIApplication.shared.open(settingURL, completionHandler: nil)
      }
    }
  }
}
