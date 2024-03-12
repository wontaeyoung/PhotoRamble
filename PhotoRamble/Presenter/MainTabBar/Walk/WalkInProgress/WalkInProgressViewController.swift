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
  
  private let timerLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textAlignment = .center
  }
  
  private lazy var timerButton = UIButton().configured {
    $0.configuration = .filled().configured {
      $0.title = "산책 시작"
      $0.cornerStyle = .large
      $0.buttonSize = .large
    }
    
    $0.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
  }
  
  private lazy var cameraButton = UIButton().configured {
    $0.configuration = .filled().configured {
      $0.title = "사진 촬영"
      $0.cornerStyle = .large
      $0.buttonSize = .large
    }
    
    $0.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
  }
  
  private lazy var selectPhotoButton = UIButton().configured {
    $0.configuration = .filled().configured {
      $0.title = "사진 선택"
      $0.cornerStyle = .large
      $0.buttonSize = .large
    }
    
    $0.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
  }
  
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
    
    selectPhotoButton.snp.makeConstraints { make in
      make.top.equalTo(cameraButton.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func setConstraint() {
    
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    let input = WalkInProgressViewModel.Input(
      takenNewPhotoDataEvent: PublishRelay<Data>()
    )
    
    imageRelay
      .compactMap {
        $0.jpegData(compressionQuality: Constant.BusinessValue.fileImageCompressionPercent)
      }
      .bind(to: input.takenNewPhotoDataEvent)
      .disposed(by: disposeBag)
    
    let output = viewModel.transform(input: input)
    
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
