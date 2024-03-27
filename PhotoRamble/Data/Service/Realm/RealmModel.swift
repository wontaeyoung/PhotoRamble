import Foundation
import RealmSwift

internal protocol RealmModel: Object {
  
  associatedtype Column: RawRepresentable where Column.RawValue == String
}
