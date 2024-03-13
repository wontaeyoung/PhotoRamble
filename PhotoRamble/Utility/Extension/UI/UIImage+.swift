//
//  UIImage+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

extension UIImage {
  var compressedJPEGData: Data? {
    let maxQuality: CGFloat = 1.0
    let minQuality: CGFloat = 0.0
    let maxSizeInBytes = BusinessValue.maxImageFileVolumeMB * 1024 * 1024
    
    // 우선 최대 품질(무압축)에서 시작
    var compressionQuality: CGFloat = maxQuality
    
    // 이미지를 JPEG 데이터로 변환
    guard var compressedData = self.jpegData(compressionQuality: compressionQuality) else { return nil }
    
    /// 용량이 최대 기준치 이하가 되었거나, 압축률이 100%가 아니면 반복 수행
    while Double(compressedData.count) > maxSizeInBytes && compressionQuality > minQuality {
      // 압축률 10% 증가 후 다시 시도
      compressionQuality -= 0.1
      
      guard let newData = self.jpegData(compressionQuality: compressionQuality) else { break }
      compressedData = newData
    }
    
    return compressedData
  }
}
