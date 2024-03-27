import Foundation
import RealmSwift

internal final class LiveRealmService: RealmService {
  
  private let realm: Realm = try! Realm()
  internal init() { }
  
  // MARK: - Create
  internal func create<T: RealmModel>(
    with object: T
  ) throws {
    try realm.write {
      realm.add(object)
    }
  }
  
  internal func create<T: RealmModel>(
    from objects: Results<T>
  ) throws {
    try realm.write {
      realm.add(objects)
    }
  }
  
  internal func create<T: RealmModel>(
    from objects: List<T>
  ) throws {
    try realm.write {
      realm.add(objects)
    }
  }
  
  internal func create<T>(type: T.Type, with values: [T.Column : Any]) throws where T : RealmModel, T.Column : Hashable {
    try realm.write {
      realm.create(type, value: values)
    }
  }
  
  
  // MARK: - Read
  internal func fetch<T: RealmModel>(
    at id: ObjectId
  ) throws -> T {
    guard let object = realm.object(ofType: T.self, forPrimaryKey: id) else {
      throw RealmError.objectNotFoundWithObjectID(id: id)
    }
    
    return object
  }
  
  internal func fetch<T: RealmModel>(
    at id: UUID
  ) throws -> T {
    guard let object = realm.object(ofType: T.self, forPrimaryKey: id) else {
      throw RealmError.objectNotFoundWithUUID(id: id)
    }
    
    return object
  }
  
  internal func fetch<T: RealmModel>() -> Results<T> {
    return realm.objects(T.self)
  }
  
  internal func fetch<T: RealmModel>(
    by column: T.Column,
    ascending: Bool
  ) -> Results<T> {
    return realm.objects(T.self)
      .sorted(byKeyPath: column.rawValue, ascending: ascending)
  }
  
  
  // MARK: - Update
  internal func update<T: RealmModel>(
    with object: T
  ) throws {
    try realm.write {
      realm.create(T.self, value: object, update: .modified)
    }
  }
  
  internal func update<T: RealmModel>(
    from objects: Results<T>
  ) throws {
    try realm.write {
      realm.create(T.self, value: objects, update: .modified)
    }
  }
  
  internal func update<T: RealmModel>(
    from objects: List<T>
  ) throws {
    try realm.write {
      realm.create(T.self, value: objects, update: .modified)
    }
  }
  
  internal func update<T: RealmModel>(
    type: T.Type,
    at id: ObjectId,
    with values: [T.Column : Any]
  ) throws {
    let columns = values.mapKeys { $0.rawValue }
    let mergedValuesWithID = ["id": id].merging(columns) { $1 }
    
    try realm.write {
      realm.create(type, value: mergedValuesWithID, update: .modified)
    }
  }
  
  
  // MARK: - Delete
  internal func delete<T: RealmModel>(
    with object: T
  ) throws {
    try realm.write {
      realm.delete(object)
    }
  }
  
  internal func delete<T: RealmModel>(
    from objects: Results<T>
  ) throws {
    try realm.write {
      realm.delete(objects)
    }
  }
  
  internal func delete<T: RealmModel>(
    from objects: List<T>
  ) throws {
    try realm.write {
      realm.delete(objects)
    }
  }
  
  internal func deleteTable<T: RealmModel>(
    tableType: T.Type
  ) throws {
    let table: Results<T> = fetch()
    
    try realm.write {
      realm.delete(table)
    }
  }
}
