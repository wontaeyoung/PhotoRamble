//
//  DiaryPhotoGridCollectionCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import UIKit
import SnapKit
import RxCocoa

final class DiaryPhotoGridCollectionCell: RXBaseCollectionViewCell {
  
  // MARK: - UI
  private let imageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(imageView)
  }
  
  override func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  }
  
  func updateUI(with image: UIImage) {
    self.imageView.image = image
  }
}
