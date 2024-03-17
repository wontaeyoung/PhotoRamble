//
//  Configurator+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit
import Toast

public protocol Configurator { }

public extension Configurator where Self: Any {
  
  mutating func apply(_ apply: (inout Self) -> Void) {
    apply(&self)
  }
  
  func applied(_ apply: (inout Self) -> Void) -> Self {
    var configurableSelf = self
    apply(&configurableSelf)
    
    return configurableSelf
  }
}

public extension Configurator where Self: AnyObject {
  
  func configure(_ apply: (Self) -> Void) {
    apply(self)
  }
  
  func configured(_ apply: (Self) -> Void) -> Self {
    apply(self)
    return self
  }
}

extension NSObject: Configurator { }
extension Array: Configurator { }
extension Dictionary: Configurator { }
extension Set: Configurator { }


extension UIButton.Configuration: Configurator { }
extension URLRequest: Configurator { }

extension Calendar: Configurator { }

extension UIListContentConfiguration: Configurator { }
extension UICollectionLayoutListConfiguration: Configurator { }
extension UIBackgroundConfiguration: Configurator { }
extension UIConfigurationTextAttributesTransformer: Configurator { }
extension AttributeScopes: Configurator { }
extension AttributeContainer: Configurator { }

extension ToastStyle: Configurator { }

extension Walk: Configurator { }
extension Diary: Configurator { }
extension Location: Configurator { }
