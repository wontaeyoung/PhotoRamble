//
//  PRAsset.swift
//  PRDesignSystem
//
//  Created by 원태영 on 3/7/24.
//

import UIKit

public enum PRAsset {
  
  public enum Color {
    
    public static let prPrimary: UIColor = UIColor(hex: "#1A3568")
    public static let prSecondary: UIColor = UIColor(hex: "#E2EDF6")
    public static let prTitle: UIColor = UIColor(hex: "#222A3A")
    public static let prMainInfo: UIColor = UIColor(hex: "#214C9E")
    public static let prSubInfo: UIColor = UIColor(hex: "#606673")
    public static let prPlaceholder: UIColor = UIColor(hex: "#A9A9A9")
  }
  
  public enum Font {
    
    private enum FontName: String {
      case extraBold = "Pretendard-ExtraBold"
      case bold = "Pretendard-Bold"
      case semiBold = "Pretendard-SemiBold"
      case medium = "Pretendard-Medium"
      case regular = "Pretendard-Regular"
      
      var name: String {
        return self.rawValue
      }
    }
    
    private static func font(_ fontName: FontName, size: CGFloat) -> UIFont {
      let coalesceWeight: UIFont.Weight
      
      switch fontName {
        case .extraBold:
          coalesceWeight = .heavy
        case .bold:
          coalesceWeight = .bold
        case .semiBold:
          coalesceWeight = .semibold
        case .medium:
          coalesceWeight = .medium
        case .regular:
          coalesceWeight = .regular
      }
      
      return .systemFont(ofSize: size, weight: coalesceWeight)
    }
    
    public static let prPrimaryButtonTitle: UIFont = font(.bold, size: 19)
    public static let prSecondaryButtonTitle: UIFont = font(.semiBold, size: 19)
    public static let prTertiaryButtonTitle: UIFont = font(.semiBold, size: 17)
    public static let prTagButtonTitle: UIFont = font(.medium, size: 13)
    public static let prMainTitleLabel: UIFont = font(.medium, size: 15)
    public static let prMainInfoLabel: UIFont = font(.semiBold, size: 15)
    public static let prSubInfoLabel: UIFont = font(.regular, size: 11)
    public static let prContentText: UIFont = font(.regular, size: 15)
  }
  
  public enum Symbol {
    
    private enum SF: String {
      
      case figureWalk = "figure.walk"
      case bookPagesFill = "book.pages.fill"
      case gearshapeFill = "gearshape.fill"
      
      case cameraViewfinder = "camera.viewfinder"
      
      case calendar = "calendar"
      case thermometerMedium = "thermometer.medium"
      case clockFill = "clock.fill"
      
      case pencilLine = "pencil.line"
      case houseAndFlagFill = "house.and.flag.fill"
      case locationFill = "location.fill"
      case cameraOnRectangleFill = "camera.on.rectangle.fill"
      case photoFillOnRectangleFill = "photo.fill.on.rectangle.fill"
      case docTextFill = "doc.text.fill"
      case buildingColumnsFill = "building.columns.fill"
      case envelopeBadgePersonCropFill = "envelope.badge.person.crop.fill"
      case trashFill = "trash.fill"
    }
    
    private static func image(_ sf: SF) -> UIImage? {
      return UIImage(systemName: sf.rawValue)
    }
    
    public static let walkTabIcon: UIImage? = image(.figureWalk)
    public static let diaryTabIcon: UIImage? = image(.bookPagesFill)
    public static let configTabIcon: UIImage? = image(.gearshapeFill)
    
    public static let takePhotoButtonIcon: UIImage? = image(.cameraViewfinder)
    
    public static let dateInfoIcon: UIImage? = image(.calendar)
    public static let temperatureInfoIcon: UIImage? = image(.thermometerMedium)
    public static let walkDistanceInfoIcon: UIImage? = image(.figureWalk)
    public static let walkTimeInfoIcon: UIImage? = image(.clockFill)
    
    public static let continueWritingConfigIcon: UIImage? = image(.pencilLine)
    public static let nearHomeConfigIcon: UIImage? = image(.houseAndFlagFill)
    public static let locationConfigIcon: UIImage? = image(.locationFill)
    public static let useCameraConfigIcon: UIImage? = image(.cameraOnRectangleFill)
    public static let usePhotoConfigIcon: UIImage? = image(.photoFillOnRectangleFill)
    public static let termsConfigIcon: UIImage? = image(.docTextFill)
    public static let licenseConfigIcon: UIImage? = image(.buildingColumnsFill)
    public static let sendToDeveloperConfigIcon: UIImage? = image(.envelopeBadgePersonCropFill)
    public static let deleteAllDiaryConfigIcon: UIImage? = image(.trashFill)
  }
}
