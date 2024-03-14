//
//  PhotoCollectionCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import UIKit
import SnapKit

final class PhotoCollectionCell: RXBaseCollectionViewCell {
  
  // MARK: - UI
  private let photoImageView = UIImageView()
  private let selectedNumberLabel = PaddingLabel(
    style: .mainInfo,
    title: nil,
    alignment: .center,
    horizontalInset: 4,
    verticalInset: 4,
    backgroundColor: PRAsset.Color.prSecondary
  )
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(photoImageView, selectedNumberLabel)
  }
  
  override func setConstraint() {
    photoImageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
    
    selectedNumberLabel.snp.makeConstraints { make in
      make.trailing.bottom.equalTo(photoImageView).inset(20)
    }
  }
  
  override func setAttribute() {
    
  }
}

extension PhotoCollectionCell {
  
  enum SelectionStyle {
    case select(number: Int)
    case deSelect
  }
  
  func updateImage(with image: UIImage) {
    photoImageView.image = image
  }
  
  func updateSelection(style: SelectionStyle) {
    switch style {
      case .select(let number):
        selectedNumberLabel.configure {
          $0.text = "\(number)"
          $0.isHidden = false
        }
        
      case .deSelect:
        selectedNumberLabel.isHidden = true
    }
  }
}
