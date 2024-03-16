//
//  WriteDiaryViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WriteDiaryViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configured {
    $0.register(DiaryPhotoCollectionCell.self, forCellWithReuseIdentifier: DiaryPhotoCollectionCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    $0.keyboardDismissMode = .onDrag
  }
  
  private var layout: UICollectionViewFlowLayout {
    let cellCount: CGFloat = 4
    let cellSpacing: CGFloat = 16
    let cellWidth: CGFloat = (UIScreen.main.bounds.width - (cellSpacing * (2 + cellCount - 1))) / cellCount
    
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = CGSize(width: cellWidth, height: cellWidth)
      $0.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
      $0.minimumInteritemSpacing = cellSpacing
      $0.scrollDirection = .horizontal
    }
  }
  
  private let dateImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.dateInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let weatherImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.temperatureInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let walkDistanceImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.walkDistanceInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let walkTimeImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.walkTimeInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let dateLabel = PRLabel(style: .mainInfo, title: "2024년 03월 16일 토요일")
  private let weatherLabel = PRLabel(style: .mainInfo, title: "7°")
  private let walkDistanceLabel = PRLabel(style: .mainInfo, title: "1.52 km")
  private let walkTimeLabel = PRLabel(style: .mainInfo, title: "02시간 24분 52초")
  
  private let diaryTextView = PRTextView(placeholder: "일기 내용을 써주세요")
  
  private let writingCompletedButton = PRButton(style: .primary, title: "다 썼어요")
  
  // MARK: - Observable
  private let photosRelay: BehaviorRelay<[UIImage]>
  private let deletePhotoButtonTapEvent = PublishRelay<Void>()
  
  // MARK: - Property
  let viewModel: WriteDiaryViewModel
  
  // MARK: - Initializer
  init(viewModel: WriteDiaryViewModel, imageDataList: [Data]) {
    self.viewModel = viewModel
    
    let photos = imageDataList.compactMap { UIImage(data: $0) }
    self.photosRelay = .init(value: photos)
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      photoCollectionView,
      dateImageView,
      weatherImageView,
      walkDistanceImageView,
      walkTimeImageView,
      dateLabel,
      weatherLabel,
      walkDistanceLabel,
      walkTimeLabel,
      diaryTextView,
      writingCompletedButton
    )
  }
  
  override func setConstraint() {
    photoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view)
      make.height.equalTo(150)
    }
    
    dateImageView.snp.makeConstraints { make in
      make.top.equalTo(photoCollectionView.snp.bottom)
      make.leading.equalTo(view).inset(20)
      make.size.equalTo(dateLabel.snp.height)
    }
    
    weatherImageView.snp.makeConstraints { make in
      make.top.equalTo(dateImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    walkDistanceImageView.snp.makeConstraints { make in
      make.top.equalTo(weatherImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    walkTimeImageView.snp.makeConstraints { make in
      make.top.equalTo(walkDistanceImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dateImageView)
      make.leading.equalTo(dateImageView.snp.trailing).offset(12)
      make.trailing.equalTo(view).inset(20)
    }
    
    weatherLabel.snp.makeConstraints { make in
      make.centerY.equalTo(weatherImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    walkDistanceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(walkDistanceImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    walkTimeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(walkTimeImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    diaryTextView.snp.makeConstraints { make in
      make.top.equalTo(walkTimeImageView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(writingCompletedButton.snp.top).offset(-20)
    }
    
    writingCompletedButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    photosRelay
      .bind(
        to: photoCollectionView.rx.items(
          cellIdentifier: DiaryPhotoCollectionCell.identifier,
          cellType: DiaryPhotoCollectionCell.self)
      ) { [weak self] index, image, cell in
        guard let self else { return }
        cell.updateImage(with: image, tapEventRelay: deletePhotoButtonTapEvent)
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Method
  
}
