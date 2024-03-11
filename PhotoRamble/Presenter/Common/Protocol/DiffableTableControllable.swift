//
//  DiffableTableControllable.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import UIKit

protocol DiffableTableControllable {
  
  associatedtype Section: Hashable
  associatedtype TableData: Hashable
  
  var dataSource: UITableViewDiffableDataSource<Section, TableData> { get }
}
