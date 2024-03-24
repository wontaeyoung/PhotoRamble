import RealmSwift

public final class LiveRealmService: RealmService {
  
  private let realm: Realm = try! Realm()
  public init() { }
  
  // MARK: - Create
  public func create<T: RealmModel>(
    with object: T
  ) throws {
    try realm.write {
      realm.add(object)
    }
  }
  
  public func create<T: RealmModel>(
    from objects: Results<T>
  ) throws {
    try realm.write {
      realm.add(objects)
    }
  }
  
  public func create<T: RealmModel>(
    from objects: List<T>
  ) throws {
    try realm.write {
      realm.add(objects)
    }
  }
  
  public func create<T>(type: T.Type, with values: [T.Column : Any]) throws where T : RealmModel, T.Column : Hashable {
    try realm.write {
      realm.create(type, value: values)
    }
  }
  
  
  // MARK: - Read
  public func fetch<T: RealmModel>(
    at id: ObjectId
  ) throws -> T {
    guard let object = realm.object(ofType: T.self, forPrimaryKey: id) else {
      throw RealmError.objectNotFoundWithID(id: id)
    }
    
    return object
  }
  
  public func fetch<T: RealmModel>() -> Results<T> {
    return realm.objects(T.self)
  }
  
  public func fetch<T: RealmModel>(
    by column: T.Column,
    ascending: Bool
  ) -> Results<T> {
    return realm.objects(T.self)
      .sorted(byKeyPath: column.rawValue, ascending: ascending)
  }
  
  
  // MARK: - Update
  public func update<T: RealmModel>(
    with object: T
  ) throws {
    try realm.write {
      realm.create(T.self, value: object, update: .modified)
    }
  }
  
  public func update<T: RealmModel>(
    from objects: Results<T>
  ) throws {
    try realm.write {
      realm.create(T.self, value: objects, update: .modified)
    }
  }
  
  public func update<T: RealmModel>(
    from objects: List<T>
  ) throws {
    try realm.write {
      realm.create(T.self, value: objects, update: .modified)
    }
  }
  
  public func update<T: RealmModel>(
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
  public func delete<T: RealmModel>(
    with object: T
  ) throws {
    try realm.write {
      realm.delete(object)
    }
  }
  
  public func delete<T: RealmModel>(
    from objects: Results<T>
  ) throws {
    try realm.write {
      realm.delete(objects)
    }
  }
  
  public func delete<T: RealmModel>(
    from objects: List<T>
  ) throws {
    try realm.write {
      realm.delete(objects)
    }
  }
}
