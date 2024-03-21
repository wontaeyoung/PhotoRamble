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
  }
  
  private var layout: UICollectionViewCompositionalLayout {
    return .init(section: .makeDynamicGridSection(itemCount: photosRelay.value.count))
  }
  
  private let dateLabel = PRLabel(style: .mainInfo, alignment: .center)
  private let contentLabel = PRLabel(style: .content).configured { $0.numberOfLines = 3 }
  
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
      dateLabel,
      contentLabel
    )
  }
  
  override func setConstraint() {
    contentView.snp.makeConstraints { make in
      make.width.equalTo(UIScreen.main.bounds.width)
    }
    
    photoCollectionView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalTo(contentView)
      make.height.equalTo(UIScreen.main.bounds.width / 2)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.top.equalTo(photoCollectionView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(contentView).inset(20)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(dateLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(contentView).inset(20)
      make.bottom.lessThanOrEqualTo(contentView).offset(-20)
    }
  }
  
  private func injectViewModel() -> DiaryCollectionListViewModel {
    let repository = ImageRepositoryImpl()
    let fetchImageFileUsecase = FetchImageFileUsecaseImpl(imageRepository: repository)
    return DiaryCollectionListViewModel(fetchImageFileUsecase: fetchImageFileUsecase)
  }
  
  func bind(diary: Diary) {
    let input = DiaryCollectionListViewModel.Input(requestPhotoImagesEvent: .init())
    let output = viewModel.transform(input: input)
    
    output.photos
      .map { $0.prefix(5) }
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
        print(photos.count)
        photoCollectionView.setCollectionViewLayout(layout, animated: true)
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
}

extension DiaryCollectionListCell {
  
  enum Section: CaseIterable {
    case main
  }
}
