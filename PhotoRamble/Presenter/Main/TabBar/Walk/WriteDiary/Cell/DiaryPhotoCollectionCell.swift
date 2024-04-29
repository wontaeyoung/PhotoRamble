//
//  DiaryPhotoCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DiaryPhotoCollectionCell: RXBaseCollectionViewCell {
  
  // MARK: - UI
  private let photoImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 10
  }
  
  private let deletePhotoButton = PRButton(style: .icon, image: UIImage(systemName: "xmark"))
  
  // MARK: - Observable
  private let indexRelay = BehaviorRelay<Int>(value: 0)
  
  // MARK: - Life Cycle
  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  override func setHierarchy() {
    contentView.addSubviews(photoImageView, deletePhotoButton)
  }
  
  override func setConstraint() {
    photoImageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
    
    deletePhotoButton.snp.makeConstraints { make in
      make.top.trailing.equalTo(photoImageView).inset(-10)
    }
  }
}

extension DiaryPhotoCollectionCell {
  
  func updateImage(with image: UIImage, at index: Int, tapEventRelay: PublishRelay<Int>) {
    photoImageView.image = image
    indexRelay.accept(index)
    
    bindDeleteButtonTapEvent(tapEventRelay: tapEventRelay)
  }
  
  private func bindDeleteButtonTapEvent(tapEventRelay: PublishRelay<Int>) {
    deletePhotoButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .withLatestFrom(indexRelay)
      .bind {
        tapEventRelay.accept($0)
      }
      .disposed(by: disposeBag)
  }
}
