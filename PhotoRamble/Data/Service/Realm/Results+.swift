import Foundation
import RealmSwift

extension Results where Element: RealmModel {
  
  enum Operator {
    enum Comparison: String {
      case less = "<"
      case lessEqual = "<="
      case equal = "=="
      case greaterEqual = ">="
      case greater = ">"
    }
  }
  
  func `where`(
    column: Element.Column,
    comparison: Operator.Comparison = .equal,
    value: any CVarArg
  ) -> Results<Element> {
    let predicateFormat: String = "\(column.rawValue) \(comparison.rawValue) %@"
    let predicate = NSPredicate(format: predicateFormat, value)
    
    return self.filter(predicate)
  }
  
  func toList() -> List<Element> {
    let list = List<Element>()
    
    return self.reduce(list) { list, element in
      list.append(element)
      return list
    }
  }
}
