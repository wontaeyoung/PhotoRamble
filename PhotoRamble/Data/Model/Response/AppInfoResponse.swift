//
//  AppInfoResponse.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/29/24.
//

import Foundation

struct AppInfoResponse: Decodable {
  let resultCount: Int
  let results: [AppInfoResult]
}

struct AppInfoResult: Decodable {
  let version: String
}
