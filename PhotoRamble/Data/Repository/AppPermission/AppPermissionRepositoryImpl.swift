//
//  AppPermissionRepositoryImpl.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import Foundation
import RxSwift
import AVFoundation

final class AppPermissionRepositoryImpl: AppPermissionRepository {
  
  func isCameraAuthorized() -> Single<Bool> {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    
    return .just(status == .authorized)
  }
}
