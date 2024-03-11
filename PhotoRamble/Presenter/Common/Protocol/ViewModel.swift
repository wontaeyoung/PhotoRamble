//
//  ViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import RxSwift

protocol ViewModel: AnyObject {
  
  associatedtype Input
  associatedtype Output
  
  // MARK: - Property
  var disposeBag: DisposeBag { get }
  
  // MARK: - Method
  func transform(input: Input) -> Output
}
