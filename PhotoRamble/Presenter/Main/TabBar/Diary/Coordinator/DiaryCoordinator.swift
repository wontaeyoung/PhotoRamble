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
    let diaryMapper = DiaryMapper()
    let locationMapper = LocationMapper()
    let walkMapper = WalkMapper(locationMapper: locationMapper)
    let walkRepository = WalkRepositoryImpl(service: service, mapper: walkMapper)
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: diaryMapper)
    
    let viewModel = DiaryListViewModel(
      walkRepository: walkRepository,
      diaryRepository: diaryRepository
    )
      .coordinator(self)
    
    let viewController = DiaryListViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.diary.navigationTitle, displayMode: .never)
      .hideBackTitle()
    
    push(viewController)
  }
  
  func showDiaryDetailView(diary: Diary, walk: Walk) {
    
    let imageRepository = ImageRepositoryImpl()
    let viewModel = DiaryDetailViewModel(diary: diary, walk: walk, imageRepository: imageRepository)
      .coordinator(self)
    
    let viewController = DiaryDetailViewController(viewModel: viewModel)
      .hideBackTitle()
      .navigationTitle(with: "내가 쓴 일기", displayMode: .never)
    
    push(viewController)
  }
}
