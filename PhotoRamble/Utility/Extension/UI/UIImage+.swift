//
//  UIImage+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

extension UIImage {

  /// 이미지 압축
  var compressedJPEGData: Data? {
    let maxQuality: CGFloat = 1.0
    let minQuality: CGFloat = 0.0
    let maxSizeInBytes = BusinessValue.maxImageFileVolumeMB * 1024 * 1024
    
    // 최대 품질(무압축)에서 시작
    var compressionQuality: CGFloat = maxQuality
    
    // 이미지를 JPEG 데이터로 변환
    guard var compressedData = self.jpegData(compressionQuality: compressionQuality) else { return nil }
    
#if DEBUG
    LogManager.shared.log(with: "압축 전 - \(Self.dataVolumnMB(data: compressedData))", to: .local, level: .debug)
#endif
    /// 용량이 최대 기준치 이하가 되었거나, 압축률이 100%가 아니면 반복 수행
    while Double(compressedData.count) > maxSizeInBytes && compressionQuality > minQuality {
      // 압축률 10% 증가 후 다시 시도
      compressionQuality -= 0.1
      
      guard let newData = self.jpegData(compressionQuality: compressionQuality) else { break }
      compressedData = newData
    }
    
#if DEBUG
    LogManager.shared.log(with: "압축 후 - \(Self.dataVolumnMB(data: compressedData))", to: .local, level: .debug)
#endif
    
    return compressedData
  }
  
  static func dataVolumnMB(data: Data) -> String {
    let value = Double(data.count) / (1024 * 1024)
    
    return NumberFormatManager.shared.toRoundedWith(from: value, fractionDigits: 2, unit: .MB)
  }
  
  /// 이미지 색상 주입
  func colored(color: UIColor) -> UIImage {
    
    return withTintColor(color, renderingMode: .alwaysOriginal)
  }
  
  /// 폰트 기반 이미지 사이즈 적용
  func fontSized(fontSize: CGFloat) -> UIImage {
    
    let font: UIFont = .systemFont(ofSize: fontSize)
    let config = SymbolConfiguration(font: font)
    
    return withConfiguration(config)
  }
  
  /// 새로운 가로 사이즈 기반 리사이징
  func resized(newWidth: CGFloat = UIScreen.main.bounds.width) -> UIImage {
    
    let scale: CGFloat = newWidth / size.width
    let newHeight: CGFloat = scale * size.height
    
    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    
    let renderImage = render.image { _ in
      return draw(in: CGRect(origin: .zero, size: size))
    }
    
    return renderImage
  }
}
