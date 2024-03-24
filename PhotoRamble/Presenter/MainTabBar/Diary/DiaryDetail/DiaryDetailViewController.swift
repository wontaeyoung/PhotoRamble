//
//  DiaryDetailViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FSPagerView

final class DiaryDetailViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let scrollView = UIScrollView()
  
  private let contentView = UIView()
  
  private lazy var photoPagerView = FSPagerView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(
      FSPagerViewCell.self,
      forCellWithReuseIdentifier: FSPagerViewCell.identifier
    )
  }
  
  private lazy var pageControl = FSPageControl().configured {
    $0.contentHorizontalAlignment = .center
    $0.backgroundColor = PRAsset.Color.prBlack.withAlphaComponent(0.05)
  }
  
  private let dateImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.dateInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let walkTimeImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.walkTimeInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let dateLabel = PRLabel(style: .mainInfo)
  
  private let walkTimeLabel = PRLabel(style: .mainInfo)
  
  private let contentLabel = PRLabel(style: .diaryContent)
  
  // MARK: - Property
  let viewModel: DiaryDetailViewModel
  private let photoPagerRelay = BehaviorRelay<[UIImage]>(value: [])
  
  // MARK: - Initializer
  init(viewModel: DiaryDetailViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(scrollView)
    
    scrollView.addSubviews(contentView)
    
    contentView.addSubviews(
      photoPagerView,
      pageControl,
      dateImageView,
      walkTimeImageView,
      dateLabel,
      walkTimeLabel,
      contentLabel
    )
  }
  
  override func setConstraint() {
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints { make in
      make.verticalEdges.equalTo(scrollView)
      make.width.equalTo(scrollView)
    }
    
    photoPagerView.snp.makeConstraints { make in
      make.top.equalTo(contentView.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(contentView)
      make.height.equalTo(photoPagerView.snp.width).multipliedBy(0.75)
    }
    
    pageControl.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(photoPagerView)
      make.bottom.equalTo(photoPagerView)
      make.height.equalTo(photoPagerView.snp.height).multipliedBy(0.1)
    }
    
    dateImageView.snp.makeConstraints { make in
      make.top.equalTo(photoPagerView.snp.bottom).offset(10)
      make.leading.equalTo(contentView).inset(20)
      make.size.equalTo(dateLabel.snp.height)
    }
    
    walkTimeImageView.snp.makeConstraints { make in
      make.top.equalTo(dateImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dateImageView)
      make.leading.equalTo(dateImageView.snp.trailing).offset(12)
      make.trailing.equalTo(contentView).inset(20)
    }
    
    walkTimeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(walkTimeImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(walkTimeImageView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(contentView).inset(20)
      make.bottom.equalTo(contentView).inset(20)
    }
  }
  
  override func bind() {
    let input = DiaryDetailViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.dateText
      .drive(dateLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.walkTimeText
      .drive(walkTimeLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.contentText
      .drive(contentLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.imageDataList
      .flatMap {
        Observable.from($0)
          .compactMap { UIImage(data: $0) }
          .toArray()
          .asDriver(onErrorJustReturn: [])
      }
      .drive(photoPagerRelay)
      .disposed(by: disposeBag)
  }
}

extension DiaryDetailViewController: FSPagerViewDelegate, FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    let numberOfItems = viewModel.numberOfItems
    updatePagerConfiguration(numberOfItems: numberOfItems)
    
    return numberOfItems
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.identifier, at: index)
    
    cell.imageView?.configure {
      $0.image = photoPagerRelay.value[index]
      $0.contentMode = .scaleAspectFill
    }
    
    return cell
  }
  
  func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    pageControl.currentPage = targetIndex
  }
  
  private func updatePagerConfiguration(numberOfItems: Int) {
    pageControl.numberOfPages = numberOfItems
    photoPagerView.isInfinite = numberOfItems > 1
  }
}
