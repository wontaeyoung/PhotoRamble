//
//  BaseViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import RxSwift

internal class RXBaseViewController: UIViewController {
  
  internal class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  internal var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  internal init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  internal func setHierarchy() { }
  internal func setConstraint() { }
  internal func setAttribute() { }
  internal func bind() { }
  
  internal override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = PRAsset.Color.prBackground
    
    setHierarchy()
    setConstraint()
    setAttribute()
    bind()
  }
}
