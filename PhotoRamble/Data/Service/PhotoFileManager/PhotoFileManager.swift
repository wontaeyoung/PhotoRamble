//
//  PhotoFileManager.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation

public final class PhotoFileManager {
  
  public static let shared = PhotoFileManager()
  private init() { }
  
  public func loadImage(router: PhotoFileRouter) throws -> Data {
    guard router.fileExist else {
      throw FileManageError.fileNotExist(path: router.filePath)
    }
    
    return try Data(contentsOf: router.fileURL, options: .mappedIfSafe)
  }
  
  public func loadImage(url: URL) -> Data? {
    return try? Data(contentsOf: url, options: .mappedIfSafe)
  }
  
  public func loadAllImages(router: PhotoFileRouter) throws -> [Data] {
    let urls = try FileManager.default.contentsOfDirectory(at: router.directoryURL, includingPropertiesForKeys: nil)
      .filter { PhotoFileRouter.FileExtension(rawValue: $0.pathExtension) != nil }
    
    return urls.compactMap { loadImage(url: $0) }
  }
  
  public func writeImage(imageData: Data, router: PhotoFileRouter) throws {
    if !router.directoryExist {
      try FileManager.default.createDirectory(at: router.directoryURL, withIntermediateDirectories: true)
    }
    
    try imageData.write(to: router.fileURL, options: .withoutOverwriting)
  }
  
  public func remove(router: PhotoFileRouter) throws {
    guard router.fileExist else { return }

    try FileManager.default.removeItem(at: router.fileURL)
  }
}
