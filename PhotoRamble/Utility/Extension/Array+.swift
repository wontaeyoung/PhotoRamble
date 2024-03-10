//
//  Array+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import RealmSwift

extension Array where Element: RealmCollectionValue {
  
  var toList: List<Element> {
    let list = List<Element>()
    list.append(objectsIn: self)
    
    return list
  }
}
