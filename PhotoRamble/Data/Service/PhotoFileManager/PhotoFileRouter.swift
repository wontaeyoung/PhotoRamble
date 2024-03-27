//
//  PhotoFileRouter.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation

internal struct PhotoFileRouter {
  
  internal enum FileExtension: String, CaseIterable {
    
    case jpg
    case png
    
    internal var name: String {
      return ".\(self.rawValue)"
    }
  }
  
  internal enum CompressionLevel {
    
    case high
    case middle
    case low
    case raw
    
    internal var percent: CGFloat {
      switch self {
        case .high:
          return 0.25
        case .middle:
          return 0.5
        case .low:
          return 0.75
        case .raw:
          return 1
      }
    }
  }
  
  internal enum FileMethod {
    
    case write
    case read
    case delete
  }
  
  
  // MARK: - Property
  internal let directory: String
  internal let fileIndex: Int
  internal let fileExtension: FileExtension
  internal let fileMethod: FileMethod
  
  internal init(directory: String, fileIndex: Int, fileExtension: FileExtension, fileMethod: FileMethod) {
    
    self.directory = directory
    self.fileIndex = fileIndex
    self.fileExtension = fileExtension
    self.fileMethod = fileMethod
  }
  
  internal var baseDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
  
  internal var path: String {
    return "photo/\(directory)"
  }
  
  internal var directoryURL: URL {
    return baseDirectory.appendingPathComponent(path)
  }
  
  internal var fileName: String {
    return directory + "_\(fileIndex)" + fileExtension.name
  }
  
  internal var fileURL: URL {
    return directoryURL.appendingPathComponent(fileName)
  }
  
  internal var directoryPath: String {
    return directoryURL.path
  }
  
  internal var filePath: String {
    return fileURL.path
  }
  
  internal var directoryExist: Bool {
    return FileManager.default.fileExists(atPath: directoryPath)
  }
  
  internal var fileExist: Bool {
    return FileManager.default.fileExists(atPath: filePath)
  }
}
