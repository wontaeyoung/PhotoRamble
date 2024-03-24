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
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: diaryMapper)
    let walkRepository = WalkRepositoryImpl(service: service, mapper: walkMapper)
    let fetchDiaryUsecase = FetchDiaryUsecaseImpl(diaryRepository: diaryRepository)
    let fetchWalkUsecase = FetchWalkUsecaseImpl(walkRepository: walkRepository)
    
    let viewModel = DiaryListViewModel(
      fetchDiaryUsecase: fetchDiaryUsecase,
      fetchWalkUsecase: fetchWalkUsecase
    )
      .coordinator(self)
    
    let viewController = DiaryListViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.diary.navigationTitle, displayMode: .never)
      .hideBackTitle()
    
    push(viewController)
  }
  
  func showDiaryDetailView(diary: Diary, walk: Walk) {
    
    let imageRepository = ImageRepositoryImpl()
    let fetchImageUsecase = FetchImageFileUsecaseImpl(imageRepository: imageRepository)
    let viewModel = DiaryDetailViewModel(diary: diary, walk: walk, fetchImageUsecase: fetchImageUsecase)
      .coordinator(self)
    
    let viewController = DiaryDetailViewController(viewModel: viewModel)
      .hideBackTitle()
    
    push(viewController)
  }
}
