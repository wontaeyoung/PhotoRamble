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
    let imageRepository = ImageRepositoryImpl()
    let createImageFileUsecase = CreateImageFileUsecaseImpl(imageRepository: imageRepository)
    let createDirectoryUsecase = CreateDirectoryUsecaseImpl(imageRepository: imageRepository)
    
    let viewModel = WalkInProgressViewModel(
      createImageFileUsecase: createImageFileUsecase,
      createDirectoryUsecase: createDirectoryUsecase
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
    let replaceImageFileUsecase = ReplaceImageFileUsecaseImpl(imageRepository: imageRepository)
    let createWalkUsecase = CreateWalkUsecaseImpl(walkRepository: walkRepository)
    
    let viewModel = WalkPhotoSelectionViewModel(
      walkRelay: walkRealy,
      replaceImageFileUsecase: replaceImageFileUsecase,
      createWalkUsecase: createWalkUsecase
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
    let diaryRepository = DiaryRepositoryImpl(service: service, mapper: mapper)
    let imageRepository = ImageRepositoryImpl()
    let createDiaryUsecase = CreateDiaryUsecaseImpl(diaryRepository: diaryRepository)
    let deleteImageFileUsecase = DeleteImageFileUsecaseImpl(imageRepository: imageRepository)
    
    let viewModel = WriteDiaryViewModel(
      style: .initial,
      walk: walk,
      diary: diary,
      createDiaryUsecase: createDiaryUsecase,
      deleteImageFileUsecase: deleteImageFileUsecase
    )
      .coordinator(self)
    
    let viewController = WriteDiaryViewController(viewModel: viewModel, imageDataList: imageDataList)
      .hideBackButton()
    
    push(viewController)
  }
}
