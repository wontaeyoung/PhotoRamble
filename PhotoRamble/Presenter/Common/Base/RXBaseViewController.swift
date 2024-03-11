//
//  BaseViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit
import RxSwift

open class RXBaseViewController: UIViewController {
  
  open class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  public var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Life Cycle
  open func setHierarchy() { }
  open func setConstraint() { }
  open func setAttribute() { }
  open func bind() { }
  
  open override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    setHierarchy()
    setConstraint()
    setAttribute()
    bind()
  }
}

