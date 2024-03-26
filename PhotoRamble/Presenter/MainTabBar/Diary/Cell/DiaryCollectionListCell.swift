//
//  DiaryCollectionListCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DiaryCollectionListCell: RXBaseCollectionViewListCell {
  
  // MARK: - UI
  private lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configured {
    $0.register(DiaryPhotoGridCollectionCell.self, forCellWithReuseIdentifier: DiaryPhotoGridCollectionCell.identifier)
    $0.isScrollEnabled = false
  }
  
  private var layout: UICollectionViewCompositionalLayout {
    return .init(section: .makeDynamicGridSection(itemCount: photosRelay.value.count))
  }
  
  private let divider = Divider(color: PRAsset.Color.prLightGray.withAlphaComponent(0.2))
  private let dateLabel = PRLabel(style: .subInfo, alignment: .right)
  private let contentLabel = PRLabel(style: .diaryContent).configured {
    $0.numberOfLines = 5
  }
  
  // MARK: - Observable
  private let photosRelay = BehaviorRelay<[UIImage]>(value: [])
  
  // MARK: - Property
  private lazy var viewModel = injectViewModel()
  
  // MARK: - Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  override func setHierarchy() {
    contentView.addSubviews(
      photoCollectionView,
      divider,
      dateLabel,
      contentLabel
    )
  }
  
  override func setConstraint() {
    contentView.snp.makeConstraints { make in
      make.width.equalTo(UIScreen.main.bounds.width - 40)
    }
    
    photoCollectionView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(contentView)
      make.height.equalTo((UIScreen.main.bounds.width - 40) / 2)
    }
    
    divider.snp.makeConstraints { make in
      make.top.equalTo(photoCollectionView.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(contentView)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.top.equalTo(divider.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(contentView).inset(20)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(dateLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(contentView).inset(20)
      make.bottom.lessThanOrEqualTo(contentView).offset(-20)
    }
  }
  
  override func setAttribute() {
    self.configure {
      $0.clipsToBounds = true
      
      $0.layer.configure {
        $0.cornerRadius = 20
        $0.borderColor = PRAsset.Color.prPrimary.withAlphaComponent(0.1).cgColor
        $0.borderWidth = 1
      }
    }
  }
  
  func bind(diary: Diary) {
    let input = DiaryCollectionListViewModel.Input(requestPhotoImagesEvent: .init())
    let output = viewModel.transform(input: input)
    
    output.photos
      .map { $0.prefix(1) }
      .flatMap {
        Observable.from($0)
          .compactMap { UIImage(data: $0) }
          .toArray()
          .asDriver(onErrorJustReturn: [])
      }
      .drive(photosRelay)
      .disposed(by: disposeBag)
    
    output.dateText
      .drive(dateLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.contentText
      .drive(contentLabel.rx.text)
      .disposed(by: disposeBag)
    
    photosRelay
      .do(onNext: { [weak self] photos in
        guard let self else { return }
        
        toggleCollectionVisibility(photosEmpty: photos.isEmpty)
        updateCollectionLayout()
      })
      .bind(to: photoCollectionView.rx.items(
        cellIdentifier: DiaryPhotoGridCollectionCell.identifier,
        cellType: DiaryPhotoGridCollectionCell.self)
      ) { row, item, cell in
        cell.updateUI(with: item)
      }
      .disposed(by: disposeBag)
    
    input.requestPhotoImagesEvent.accept(diary)
  }
  
  private func injectViewModel() -> DiaryCollectionListViewModel {
    let repository = ImageRepositoryImpl()
    let fetchImageFileUsecase = FetchImageFileUsecaseImpl(imageRepository: repository)
    return DiaryCollectionListViewModel(fetchImageFileUsecase: fetchImageFileUsecase)
  }
  
  private func updateCollectionLayout() {
    photoCollectionView.setCollectionViewLayout(layout, animated: true)
  }
  
  private func toggleCollectionVisibility(photosEmpty: Bool) {
    photoCollectionView.snp.updateConstraints { make in
      make.height.equalTo(photosEmpty ? 0 : (UIScreen.main.bounds.width - 40) / 2)
    }
    
    divider.isHidden = photosEmpty
  }
}

extension DiaryCollectionListCell {
  
  enum Section: CaseIterable {
    case main
  }
}
