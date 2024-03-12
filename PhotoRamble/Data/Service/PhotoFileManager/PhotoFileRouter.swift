//
//  PhotoFileRouter.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/11/24.
//

import Foundation

public struct PhotoFileRouter {
  
  public enum FileExtension: String, CaseIterable {
    
    case jpg
    case png
    
    public var name: String {
      return ".\(self.rawValue)"
    }
  }
  
  public enum CompressionLevel {
    
    case high
    case middle
    case low
    case raw
    
    public var percent: CGFloat {
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
  
  public enum FileMethod {
    
    case write
    case read
    case delete
  }
  
  
  // MARK: - Property
  public let directory: String
  public let fileIndex: Int
  public let fileExtension: FileExtension
  public let fileMethod: FileMethod
  
  public init(directory: String, fileIndex: Int, fileExtension: FileExtension, fileMethod: FileMethod) {
    
    self.directory = directory
    self.fileIndex = fileIndex
    self.fileExtension = fileExtension
    self.fileMethod = fileMethod
  }
  
  public var baseDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
  
  public var path: String {
    return "photo/\(directory)"
  }
  
  public var directoryURL: URL {
    return baseDirectory.appendingPathComponent(path)
  }
  
  public var fileName: String {
    return directory + "_\(fileIndex)" + fileExtension.name
  }
  
  public var fileURL: URL {
    return directoryURL.appendingPathComponent(fileName)
  }
  
  public var directoryPath: String {
    return directoryURL.path
  }
  
  public var filePath: String {
    return fileURL.path
  }
  
  public var directoryExist: Bool {
    return FileManager.default.fileExists(atPath: directoryPath)
  }
  
  public var fileExist: Bool {
    return FileManager.default.fileExists(atPath: filePath)
  }
}
