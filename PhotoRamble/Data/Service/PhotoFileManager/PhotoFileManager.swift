//
//  PhotoFileManager.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation

internal final class PhotoFileManager {
  
  internal static let shared = PhotoFileManager()
  private init() { }
  
  internal func loadImage(router: PhotoFileRouter) throws -> Data {
    guard router.fileExist else {
      throw FileManageError.fileNotExist(path: router.filePath)
    }
    
    return try Data(contentsOf: router.fileURL, options: .mappedIfSafe)
  }
  
  internal func loadImage(url: URL) -> Data? {
    return try? Data(contentsOf: url, options: .mappedIfSafe)
  }
  
  internal func loadAllImages(router: PhotoFileRouter) throws -> [Data] {
    let urls = try FileManager.default.contentsOfDirectory(at: router.directoryURL, includingPropertiesForKeys: nil)
      .filter { PhotoFileRouter.FileExtension(rawValue: $0.pathExtension) != nil }
    
    return urls.compactMap { loadImage(url: $0) }
  }
  
  internal func writeImage(imageData: Data, router: PhotoFileRouter) throws {
    if !router.directoryExist {
      try FileManager.default.createDirectory(at: router.directoryURL, withIntermediateDirectories: true)
    }
    
    #if DEBUG
    LogManager.shared.log(with: "이미지 파일 저장 위치 : " + router.filePath, to: .local, level: .debug)
    #endif
    
    try imageData.write(to: router.fileURL, options: .withoutOverwriting)
  }
  
  internal func remove(router: PhotoFileRouter) throws {
    guard router.fileExist else { return }

    try FileManager.default.removeItem(at: router.fileURL)
  }
  
  internal func removeAll(router: PhotoFileRouter) throws {
    guard router.directoryExist else { return }
    
    try FileManager.default.contentsOfDirectory(at: router.directoryURL, includingPropertiesForKeys: nil).forEach {
      try FileManager.default.removeItem(at: $0)
    }
  }
  
  internal func createDirectory(router: PhotoFileRouter) throws {
    guard !router.directoryExist else { return }
    
    try FileManager.default.createDirectory(at: router.directoryURL, withIntermediateDirectories: true)
  }
}
