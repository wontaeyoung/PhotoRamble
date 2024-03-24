import RealmSwift

public enum RealmError: Error {
  
  case getRealmFailed
  case observedChangeError(error: Error?)
  case addFailed(error: Error?)
  case updateFailed(error: Error?)
  case removeFailed(error: Error?)
  case fetchFailed(error: Error?)
  case objectNotFoundWithID(id: ObjectId)
  
  var logDescription: String {
    switch self {
      case .getRealmFailed:
        return "Realm 데이터베이스 객체를 생성하는데 실패했습니다."
        
      case .observedChangeError(let error):
        return "감지된 변경사항에서 에러가 발생했습니다. \(error?.localizedDescription ?? "")"
        
      case .addFailed(let error):
        return "데이터 추가에 실패했습니다. \(error?.localizedDescription ?? "")"
        
      case .updateFailed(let error):
        return "데이터 업데이트에 실패했습니다. \(error?.localizedDescription ?? "")"
        
      case .removeFailed(let error):
        return "데이터 삭제에 실패했습니다. \(error?.localizedDescription ?? "")"
        
      case .fetchFailed(let error):
        return "데이터 로드에 실패했습니다. \(error?.localizedDescription ?? "")"
      
      case .objectNotFoundWithID(let id):
        return "ID에 해당하는 객체를 찾을 수 없습니다. ID: \(id.stringValue)"
    }
  }
}
