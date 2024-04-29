//
//  PhotoSelectionCollectionCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import UIKit
import SnapKit

final class PhotoSelectionCollectionCell: RXBaseCollectionViewCell {
  
  // MARK: - UI
  private let photoImageView = UIImageView()
  private let selectedView = UIView().configured {
    $0.backgroundColor = PRAsset.Color.prBlack.withAlphaComponent(0.5)
    $0.isHidden = true
  }
  private lazy var selectedNumberLabel = PRLabel(style: .mainTitle, alignment: .center).configured {
    $0.backgroundColor = PRAsset.Color.prSecondary
    $0.clipsToBounds = true
    $0.layer.cornerRadius = selectedNumberLabelSize / 2
    $0.isHidden = true
  }
  
  private let selectedNumberLabelSize: CGFloat = 25
  
  // MARK: - Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    selectedNumberLabel.text = ""
  }
  override func setHierarchy() {
    contentView.addSubviews(photoImageView, selectedView, selectedNumberLabel)
  }
  
  override func setConstraint() {
    photoImageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
    
    selectedView.snp.makeConstraints { make in
      make.edges.equalTo(photoImageView)
    }
    
    selectedNumberLabel.snp.makeConstraints { make in
      make.top.trailing.equalTo(photoImageView).inset(8)
      make.size.equalTo(selectedNumberLabelSize)
    }
  }
  
  override func setAttribute() {
    contentView.layer.borderColor = PRAsset.Color.prPrimary.cgColor
  }
}

extension PhotoSelectionCollectionCell {
  
  func updateImage(with image: UIImage, selectedNumber: Int?) {
    photoImageView.image = image
    
    updateSelection(selectedNumber: selectedNumber)
    selectedNumberLabelVisible()
    selectedImageStyleVisible()
  }
  
  private func updateSelection(selectedNumber: Int?) {
    if let selectedNumber {
      selectedNumberLabel.text = "\(selectedNumber)"
    }
  }
  
  private func selectedNumberLabelVisible() {
    if let isEmpty = selectedNumberLabel.text?.isEmpty {
      selectedNumberLabel.isHidden = isEmpty
    }
  }
  
  private func selectedImageStyleVisible() {
    if let isEmpty = selectedNumberLabel.text?.isEmpty {
      selectedView.isHidden = isEmpty
    }
  }
}
