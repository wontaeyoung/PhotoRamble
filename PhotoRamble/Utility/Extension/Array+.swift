//
//  Array+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import RealmSwift

extension Array {
  
  func removed(at index: Int) -> Self {
    guard self.indices ~= index else { return self }
    
    var mutableList = self
    mutableList.remove(at: index)
    
    return mutableList
  }
}

extension Array where Element: RealmCollectionValue {
  
  var toList: List<Element> {
    let list = List<Element>()
    list.append(objectsIn: self)
    
    return list
  }
}
