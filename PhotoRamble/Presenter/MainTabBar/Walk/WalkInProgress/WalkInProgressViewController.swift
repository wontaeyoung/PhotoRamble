//
//  WalkInProgressViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FSPagerView

final class WalkInProgressViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var takenPhotoPagerView = FSPagerView().configured {
    $0.transformer = FSPagerViewTransformer(type: .overlap)
    $0.delegate = self
    $0.dataSource = self
    $0.register(
      FSPagerViewCell.self,
      forCellWithReuseIdentifier: FSPagerViewCell.identifier
    )
    
    let size = UIScreen.main.bounds.width * 0.6
    $0.itemSize = .init(width: size, height: size)
  }
  
  private let noPhotoInfoLabel = PRLabel(
    style: .subInfo,
    title: Localization.no_photo_info_label.localized,
    alignment: .center
  )
  
  private let timerLabel = PRLabel(
    style: .timer,
    title: Constant.timerStartText,
    alignment: .center
  )
  
  private let cameraButton = PRButton(
    style: .secondary,
    title: Localization.photo_take_button.localized,
    image: PRAsset.Symbol.takePhotoButtonIcon
  )
  
  private let walkCompleteButton = PRButton(
    style: .primary,
    title: Localization.walk_complete_button.localized
  )
  
  // MARK: - Property
  let viewModel: WalkInProgressViewModel
  private let imageRelay = PublishRelay<UIImage>()
  private let photoPagerRelay = BehaviorRelay<[UIImage]>(value: [])
  
  // MARK: - Initializer
  init(viewModel: WalkInProgressViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  deinit {
#if DEBUG
    LogManager.shared.log(with: "\(self.description) 해제", to: .local, level: .debug)
#endif
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      takenPhotoPagerView,
      noPhotoInfoLabel,
      timerLabel,
      cameraButton,
      walkCompleteButton
    )
  }
  
  override func setConstraint() {
    takenPhotoPagerView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(takenPhotoPagerView.snp.width)
    }
    
    noPhotoInfoLabel.snp.makeConstraints { make in
      make.edges.equalTo(takenPhotoPagerView).inset(20)
      make.center.equalTo(takenPhotoPagerView)
    }
    
    timerLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(cameraButton.snp.top).offset(-20)
    }
    
    cameraButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(walkCompleteButton.snp.top).offset(-20)
    }
    
    walkCompleteButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
    }
  }
  
  override func bind() {
    
    let input = WalkInProgressViewModel.Input(
      viewDidLoadEvent: .init(),
      takenNewPhotoDataEvent: PublishRelay<Data>(),
      walkCompleteButtonTapEvent: PublishRelay<Void>()
    )
    
    let output = viewModel.transform(input: input)
    
    /// UIImage -> Data 변환 후 전달
    imageRelay
      .compactMap { $0.compressedJPEGData }
      .bind(to: input.takenNewPhotoDataEvent)
      .disposed(by: disposeBag)
    
    imageRelay
      .observe(on: MainScheduler.instance)
      .asObservable()
      .take(1)
      .subscribe(with: self, onNext: { owner, _ in
        owner.hideNoPhotoLabel()
      })
      .disposed(by: disposeBag)
    
    cameraButton.rx.tap
      .bind(with: self, onNext: { owner, _ in
        owner.showingCamera()
      })
      .disposed(by: disposeBag)
    
    walkCompleteButton.rx.tap
      .bind(to: input.walkCompleteButtonTapEvent)
      .disposed(by: disposeBag)
    
    /// [Data] -> [UIImage] 변환 후 사진 리스트 업데이트
    output.imageDataList
      .flatMap {
        Observable.from($0)
          .compactMap { UIImage(data: $0) }
          .toArray()
          .asDriver(onErrorJustReturn: [])
      }
      .drive(photoPagerRelay)
      .disposed(by: disposeBag)
    
    output.timerLabelText
      .emit(to: timerLabel.rx.text)
      .disposed(by: disposeBag)
    
    photoPagerRelay
      .asDriver()
      .drive(with: self, onNext: { owner, _ in
        owner.updatePhotoCollection()
        
        GCD.main(after: 0.1) {
          let scrollTargetItem = owner.viewModel.numberOfItems - 1
          owner.takenPhotoPagerView.scrollToItem(at: scrollTargetItem, animated: true)
        }
      })
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
  
  private func showingCamera() {
#if targetEnvironment(simulator)
    viewModel.requestImageForSimulator()
      .compactMap { UIImage(data: $0) }
      .bind(to: imageRelay)
      .disposed(by: disposeBag)
#else
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let picker = UIImagePickerController().configured {
        $0.sourceType = .camera
        $0.cameraCaptureMode = .photo
        $0.delegate = self
      }
      
      present(picker, animated: true)
    }
#endif
  }
  
  private func hideNoPhotoLabel() {
    noPhotoInfoLabel.removeFromSuperview()
  }
  
  private func updatePhotoCollection() {
    takenPhotoPagerView.reloadData()
  }
}

extension WalkInProgressViewController: FSPagerViewDataSource, FSPagerViewDelegate {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return viewModel.numberOfItems
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(
      withReuseIdentifier: FSPagerViewCell.identifier,
      at: index
    )
    
    cell.imageView?.configure {
      $0.image = photoPagerRelay.value[index]
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 20

#if DEBUG
      LogManager.shared.log(with: "표시 이미지 용량 - " + UIImage.dataVolumnMB(data: $0.image!.jpegData(compressionQuality: 1.0)!) , to: .local, level: .debug)
#endif
    }
    
    return cell
  }
}

extension WalkInProgressViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true)
    
    if let image = info[.originalImage] as? UIImage {
      imageRelay.accept(image)
    }
  }
}
