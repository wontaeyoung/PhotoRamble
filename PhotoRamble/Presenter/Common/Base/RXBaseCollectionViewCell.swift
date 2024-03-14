//
//  RXBaseCollectionViewCell.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import UIKit
import RxSwift

open class RXBaseCollectionViewCell: UICollectionViewCell {
  
  open class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  public var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  public override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    setHierarchy()
    setConstraint()
    setAttribute()
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  open func setHierarchy() { }
  open func setConstraint() { }
  open func setAttribute() { }
}
