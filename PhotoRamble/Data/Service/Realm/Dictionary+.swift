public extension Dictionary {
  func mapKeys<K: Hashable>(_ transform: (Key) -> K) -> [K: Value] {
    var newDict: [K: Value] = [:]
    
    self.forEach {
      let transformedKey = transform($0.key)
      newDict.updateValue($0.value, forKey: transformedKey)
    }
    
    return newDict
  }
}
