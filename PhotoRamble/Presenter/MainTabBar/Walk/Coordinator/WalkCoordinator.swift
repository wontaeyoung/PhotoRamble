//
//  WalkCoordinator.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import RxRelay

final class WalkCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var tabBarDelegate: TabBarDelegate?
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
      .coordinator(self)
    
    let viewController = WalkViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.walk.navigationTitle, displayMode: .never)
      .hideBackButton()
    
    push(viewController)
  }
  
  func showWalkInProgressView() {
    let service = LiveRealmService()
    let locationMapper = LocationMapper()
    let walkMapper = WalkMapper(locationMapper: locationMapper)
    let imageRepository = ImageRepositoryImpl()
    let walkRepository = WalkRepositoryImpl(service: service, mapper: walkMapper)
    
    let viewModel = WalkInProgressViewModel(
      imageRepository: imageRepository, 
      walkRepository: walkRepository
    )
      .coordinator(self)
    
    let viewController = WalkInProgressViewController(viewModel: viewModel)
      .navigationTitle(with: "산책하기", displayMode: .never)
      .hideBackButton()
      .hideTabBar()
    
    push(viewController)
  }
  
  func showWalkPhotoSelectionView(walkRealy: BehaviorRelay<Walk>, imageDataList: [Data]) {
    
    let service = LiveRealmService()
    let locationMapper = LocationMapper()
    let walkMapper = WalkMapper(locationMapper: locationMapper)
    let imageRepository = ImageRepositoryImpl()
    let walkRepository = WalkRepositoryImpl(service: service, mapper: walkMapper)
    
    let viewModel = WalkPhotoSelectionViewModel(
      walkRelay: walkRealy,
      imageRepository: imageRepository,
      walkRepository: walkRepository
    )
      .coordinator(self)
    
    let viewcontroller = WalkPhotoSelectionViewController(viewModel: viewModel, imageDataList: imageDataList)
      .navigationTitle(with: "사진 선택하기", displayMode: .never)
      .hideBackButton()
    
    push(viewcontroller)
  }
  
  func showWriteDiaryView(walk: Walk, diary: Diary, imageDataList: [Data]) {
    let service = LiveRealmService()
    let mapper = DiaryMapper()
    let imageRepository = ImageRepositoryImpl()
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: mapper)
    
    let viewModel = WriteDiaryViewModel(
      style: .initial,
      walk: walk,
      diary: diary,
      imageRepository: imageRepository,
      diaryRepository: diaryRepository
    )
      .coordinator(self)
    
    let viewController = WriteDiaryViewController(
      viewModel: viewModel,
      style: .initial,
      imageDataList: imageDataList
    )
      .hideBackButton()
    
    push(viewController)
  }
}
