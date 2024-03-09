//
//  UUID+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/10/24.
//

import Foundation

extension UUID {
  static func from(string: String) throws -> UUID {
    guard let uuid = UUID(uuidString: string) else {
      throw MapperError.toUUIDFailed(from: string)
    }
    return uuid
  }
}
