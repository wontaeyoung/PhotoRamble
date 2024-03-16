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
    let viewModel = WalkInProgressViewModel(createImageFileUsecase: createImageFileUsecase)
      .coordinator(self)
    let viewController = WalkInProgressViewController(viewModel: viewModel)
      .navigationTitle(with: "산책하기", displayMode: .never)
      .hideBackButton()
    
    push(viewController)
  }
  
  func showWalkPhotoSelectionView(walkRealy: BehaviorRelay<Walk>, imageDataList: [Data]) {
    let imageRepository = ImageRepositoryImpl()
    let replaceImageFileUsecase = ReplaceImageFileUsecaseImpl(imageRepository: imageRepository)
    
    let viewModel = WalkPhotoSelectionViewModel(
      walkRelay: walkRealy,
      replaceImageFileUsecase: replaceImageFileUsecase
    )
      .coordinator(self)
    
    let viewcontroller = WalkPhotoSelectionViewController(viewModel: viewModel, imageDataList: imageDataList)
      .navigationTitle(with: "사진 선택하기", displayMode: .never)
      .hideBackButton()
    
    push(viewcontroller)
  }
  
  func showWriteDiaryView(imageDataList: [Data]) {
    let viewController = WriteDiaryViewController(viewModel: WriteDiaryViewModel(), imageDataList: imageDataList)
      .hideBackButton()
    
    push(viewController)
  }
}
