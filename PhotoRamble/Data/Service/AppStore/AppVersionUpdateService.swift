//
//  AppVersionUpdateService.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/29/24.
//

import Foundation

enum AppStoreUpdateError: Error {
  case invalidInfoDictionary
  case invalidBundleID
  case invalidCurrentVersionNumber
  case invalidItunesURL
  case invalidResponse
  case failToDecoding
  case unexpectedStatusCode
  case unknown
  case emptyResponse
  case invalidVersionFormat
}

final class AppVersionUpdateService {
  
  /// 단순 버전 확인 및 표시를 위해 버전 조회
  static func fetchVersion() -> Result<String, AppStoreUpdateError> {
    guard var currentVersion = Bundle.main.object(forInfoDictionaryKey: Constant.InfoKey.versionString) as? String else {
      return .failure(.invalidInfoDictionary)
    }
    
    if currentVersion.components(separatedBy: ".").count <= 2 {
      currentVersion += ".0"
    }
    
    guard isValidPattern(text: currentVersion, pattern: Constant.RegPattern.appVersion) else {
      return .failure(.invalidVersionFormat)
    }
    
    return .success(currentVersion)
  }
  
  /// 클라이언트의 메이저 버전이 더 낮은지 검사하는 메서드
  private static func compareVersion(
    client: String,
    store: String
  ) -> Result<Bool, AppStoreUpdateError> {
    
    // 두 버전 값이 패턴에 일치하는지, 문자열로 된 숫자가 Int로 변환이 되는지 검사
    guard
      isValidPattern(text: client, pattern: Constant.RegPattern.appVersion),
      isValidPattern(text: store, pattern: Constant.RegPattern.appVersion)
    else {
      return .failure(.invalidVersionFormat)
    }
    
    var clientVersionArr: [Int?] = client.components(separatedBy: ".").map{Int($0)}
    var storeVersionArr: [Int?] = store.components(separatedBy: ".").map{Int($0)}
    
    guard
      let clientMajor: Int = clientVersionArr.removeFirst(),
      let storeMajor: Int = storeVersionArr.removeFirst()
    else {
      return .failure(.invalidVersionFormat)
    }
    
    var isNewVersionAvailable: Bool = clientMajor < storeMajor
    
    return .success(isNewVersionAvailable)
  }
  
  static func isNewVersionAvailable() async -> Result<Bool, AppStoreUpdateError> {
    // 앱 번들 인포 리스트 딕셔너리
    guard let infoDictionary = Bundle.main.infoDictionary else {
      return .failure(.invalidInfoDictionary)
    }
    
    // 앱 번들 ID
    guard let bundleID = Bundle.main.bundleIdentifier else {
      return .failure(.invalidBundleID)
    }
    
    /// 앱 버전
    /// ex) 1.0.0
    guard var currentVersionNumber = infoDictionary[Constant.InfoKey.versionString] as? String else {
      return .failure(.invalidCurrentVersionNumber)
    }
    
    /// 클라이언트에서 제공하는 앱 버전은 마지막 숫자가 0이면 스킵하여 제공함
    /// ex) 1.0.0 -> 1.0
    /// API에서 제공받은 버전과 비교하기 위해 스킵된 경우 동일한 형식으로 맞추기 위해 .0을 뒤에 추가
    if currentVersionNumber.components(separatedBy: ".").count <= 2 {
      currentVersionNumber += ".0"
    }
    
    // ItunesAPI 요청 URL
    guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
      return .failure(.invalidItunesURL)
    }
    
    do {
      let (data, urlResponse) = try await URLSession.shared.data(from: url)
      
      guard let response = urlResponse as? HTTPURLResponse else {
        return .failure(.invalidResponse)
      }
      
      guard 200...299 ~= response.statusCode else {
        return .failure(.unexpectedStatusCode)
      }
      
      guard let decodedResponse = try? JSONDecoder().decode(
        AppInfoResponse.self,
        from: data
      ) else {
        return .failure(.failToDecoding)
      }
      
      // decoded된 AppInfo 객체는 Lookup API 특성상 results 배열이 비어있는 경우(0), 정보가 정상적으로 담긴 경우(1)가 존재합니다.
      guard let latestVersionNumber = decodedResponse.results.first?.version else {
        return .failure(.emptyResponse)
      }
      
      let compareVersionResult = compareVersion(
        client: currentVersionNumber,
        store: latestVersionNumber
      )
      
      switch compareVersionResult {
        case .success(let isAvailableNewVersion):
          return .success(isAvailableNewVersion)
          
        case .failure(let error):
          return .failure(error)
      }
      
    } catch {
      return .failure(.unknown)
    }
  }
  
  private static func isValidPattern(text: String, pattern: String) -> Bool {
    return text.range(of: pattern, options: .regularExpression) != nil
  }
}
