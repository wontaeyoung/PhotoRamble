//
//  DiaryCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import UIKit
import RxRelay

final class DiaryCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showDiaryListView()
  }
}

extension DiaryCoordinator {
  func showDiaryListView() {
    
    let service = LiveRealmService()
    let mapper = DiaryMapper()
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: mapper)
    let fetchDiaryUsecase = FetchDiaryUsecaseImpl(diaryRepository: diaryRepository)
    
    let viewModel = DiaryListViewModel(fetchDiaryUsecase: fetchDiaryUsecase)
      .coordinator(self)
    
    let viewController = DiaryListViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.diary.navigationTitle, displayMode: .never)
      .hideBackTitle()
    
    push(viewController)
  }
}
