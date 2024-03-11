//
//  ViewModelController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

protocol ViewModelController: AnyObject {
  associatedtype ViewModelType = ViewModel
  
  var viewModel: ViewModelType { get }
}

