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
    $0.itemSize = .init(width: 250, height: 250)
  }
  
  private let timerLabel = PRLabel(style: .mainInfo, title: "00:00:00").configured {
    $0.textAlignment = .center
  }
  
  private let timerButton = PRButton(
    style: .secondary,
    title: Localization.walk_start_button.localized
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
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      takenPhotoPagerView,
      timerLabel,
      timerButton,
      cameraButton,
      walkCompleteButton
    )
  }
  
  override func setConstraint() {
    takenPhotoPagerView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(takenPhotoPagerView.snp.width)
    }
    
    timerLabel.snp.makeConstraints { make in
      make.top.equalTo(takenPhotoPagerView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    timerButton.snp.makeConstraints { make in
      make.top.equalTo(timerLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    cameraButton.snp.makeConstraints { make in
      make.top.equalTo(timerButton.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    walkCompleteButton.snp.makeConstraints { make in
      make.top.equalTo(cameraButton.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = WalkInProgressViewModel.Input(
      takenNewPhotoDataEvent: PublishRelay<Data>(),
      timerToggleEvent: PublishRelay<Void>()
    )
    
    /// UIImage -> Data 변환 후 전달
    imageRelay
      .compactMap {
        $0.jpegData(compressionQuality: Constant.BusinessValue.fileImageCompressionPercent)
      }
      .bind(to: input.takenNewPhotoDataEvent)
      .disposed(by: disposeBag)
    
    /// 타이머 버튼 탭 이벤트 전달
    timerButton.rx.tap
      .bind(to: input.timerToggleEvent)
      .disposed(by: disposeBag)
    
    let output = viewModel.transform(input: input)
    
    /// [Data] -> [UIImage] 변환 후 사진 리스트 업데이트
    output.imageDataUpdated
      .flatMap {
        Observable.from($0)
          .compactMap { UIImage(data: $0) }
          .toArray()
      }
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: { [weak self] images in
        guard let self else { return }
        photoPagerRelay.accept(images)
      })
      .disposed(by: disposeBag)
    
    output.timerButtonText
      .drive(onNext: { [weak self] in
        guard let self else { return }
        
        timerButton.title($0)
      })
      .disposed(by: disposeBag)
    
    output.timerLabelText
      .drive(timerLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Method
  
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
    
    cell.imageView?.image = photoPagerRelay.value[index]
    
    return cell
  }
}
