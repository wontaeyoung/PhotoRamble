import Foundation
import RealmSwift

public protocol RealmModel: Object {
  
  associatedtype Column: RawRepresentable where Column.RawValue == String
}
