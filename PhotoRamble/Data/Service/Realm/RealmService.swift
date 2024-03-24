/// Realm Update Policy
///
/// 데이터 생성을 시도했을 때 객체가 이미 있는 경우, 어떻게 처리할 것인지
///
/// .all: 전달한 새 객체의 데이터로 모두 덮어쓰기
/// .error: 데이터 무결성을 위해 작업을 수행하지 않고 에러 발생
/// .modified: 전달한 객체에서 기존 객체와 다른 컬럼만 덮어쓰기
///
/// all과 modified는 수행 결과 데이터는 동일하지만, 성능적인 차이가 있음
/// 기본값은 error로 되어있음
///
///
/// Realm add vs create
///
/// Add
/// - Realm 객체 인스턴스를 가지고 생성함
/// - 객체가 이미 메모리에 있을 때 사용함
/// - 객체의 필드 값이 이미 설정되어있어야 함
///
/// Create
/// - 딕셔너리를 가지고 Realm 객체를 생성함
/// - Add처럼 인스턴스를 가지고 생성하는 것도 지원함
/// - 기존 객체가 없을 때, 딕셔너리에 필수 값이 포함되어있지 않으면 에러가 발생할 수 있음

import RealmSwift

public protocol RealmService {
  
  // MARK: - Method
  // MARK: Create
  /// 전달받은 객체를 테이블에 추가합니다.
  /// - Parameters:
  ///   - with object: 테이블에 추가할 객체 인스턴스입니다.
  func create<T: RealmModel>(with object: T) throws
  
  /// 전달받은 객체들을 테이블에 추가합니다.
  /// - Parameters:
  ///   - from objects: 테이블에 추가할 객체 인스턴스들입니다.
  func create<T: RealmModel>(type: T.Type, with values: [T.Column: Any]) throws
  
  /// 전달받은 객체들을 테이블에 추가합니다.
  /// - Parameters:
  ///   - from objects: 테이블에 추가할 객체 인스턴스들입니다.
  func create<T: RealmModel>(from objects: Results<T>) throws
  
  /// 전달받은 딕셔너리로 새 객체를 생성하고 테이블에 추가합니다.
  /// - Parameters:
  ///   - type: 생성할 객체의 타입입니다.
  ///   - with values: 생성할 객체의 레코드입니다.
  func create<T: RealmModel>(from objects: List<T>) throws
  
  func fetch<T: RealmModel>(at id: ObjectId) throws -> T
  func fetch<T: RealmModel>() -> Results<T>
  func fetch<T: RealmModel>(by column: T.Column, ascending: Bool) -> Results<T>
  
  func update<T: RealmModel>(with object: T) throws
  func update<T: RealmModel>(from objects: Results<T>) throws
  func update<T: RealmModel>(type: T.Type, at id: ObjectId, with values: [T.Column: Any]) throws
  
  func delete<T: RealmModel>(with object: T) throws
  func delete<T: RealmModel>(from objects: Results<T>) throws
}
