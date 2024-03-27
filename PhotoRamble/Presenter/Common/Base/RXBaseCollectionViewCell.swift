//
//  RXBaseCollectionViewCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import UIKit
import RxSwift

internal class RXBaseCollectionViewCell: UICollectionViewCell {
  
  internal class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  internal var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  internal override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    setHierarchy()
    setConstraint()
    setAttribute()
  }
  
  @available(*, unavailable)
  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  internal func setHierarchy() { }
  internal func setConstraint() { }
  internal func setAttribute() { }
}
