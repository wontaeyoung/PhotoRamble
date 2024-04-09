//
//  PRAsset.swift
//  PRDesignSystem
//
//  Created by 원태영 on 3/7/24.
//

import UIKit

enum PRAsset {
  
  enum Color {
    
    static let prPrimary: UIColor = UIColor(hex: "#1A3568")
    static let prSecondary: UIColor = UIColor(hex: "#E2EDF6")
    static let prBackground: UIColor = UIColor(hex: "#F4FBFD")
    static let prTitle: UIColor = UIColor(hex: "#222A3A")
    static let prMainInfo: UIColor = UIColor(hex: "#214C9E")
    static let prSubInfo: UIColor = UIColor(hex: "#606673")
    static let prPlaceholder: UIColor = UIColor(hex: "#A9A9A9")
    static let prWhite: UIColor = UIColor(hex: "#FFFFFF")
    static let prBlack: UIColor = UIColor(hex: "#000000")
    static let prToastBacgrkound: UIColor = UIColor(hex: "#F3F4F6")
    static let prLightGray: UIColor = UIColor(hex: "#B4B4B4")
    static let prRed: UIColor = UIColor(hex: "#FF3B30")
  }
  
  enum Font {
    
    private enum Name: String {
      
      case extraBold = "Pretendard-ExtraBold"
      case bold = "Pretendard-Bold"
      case semiBold = "Pretendard-SemiBold"
      case medium = "Pretendard-Medium"
      case regular = "Pretendard-Regular"
      case diaryContent = "omyu_pretty"
      
      var name: String {
        return self.rawValue
      }
    }
    
    private static func font(_ fontName: Name, size: CGFloat) -> UIFont {
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
          
        default:
          coalesceWeight = .regular
      }
      
      return UIFont(name: fontName.name, size: size) ?? .systemFont(ofSize: size, weight: coalesceWeight)
    }
    
    static let prPrimaryButtonTitle: UIFont = font(.bold, size: 19)
    static let prSecondaryButtonTitle: UIFont = font(.semiBold, size: 17)
    static let prTertiaryButtonTitle: UIFont = font(.semiBold, size: 17)
    static let prTagButtonTitle: UIFont = font(.medium, size: 13)
    
    static let prToastTitle: UIFont = font(.bold, size: 17)
    static let prToastMessage: UIFont = font(.semiBold, size: 15)
    
    static let prTimerLabel: UIFont = font(.semiBold, size: 19)
    static let prPrimaryInfoLabel: UIFont = font(.bold, size: 21)
    static let prMainInfoLabel: UIFont = font(.semiBold, size: 15)
    static let prSubInfoLabel: UIFont = font(.regular, size: 15)
    static let prCaptionLabel: UIFont = font(.regular, size: 11)
    
    static let prContentText: UIFont = font(.regular, size: 15)
    static let prNavigationTitleLabel: UIFont = font(.extraBold, size: 29)
    
    static let prDiaryText: UIFont = font(.diaryContent, size: 25)
    static let prDiaryLabel: UIFont = font(.diaryContent, size: 21)
  }
  
  enum Symbol {
    
    private enum SF: String {
      
      case figureWalk = "figure.walk"
      case figureWalkMotion = "figure.walk.motion"
      case textBookClosed = "text.book.closed"
      case textBookClosedFill = "text.book.closed.fill"
      case gearshape = "gearshape"
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
      
      case xmark = "xmark"
    }
    
    private static func sfImage(_ sf: SF) -> UIImage? {
      return UIImage(systemName: sf.rawValue)
    }
    
    static let walkTabIcon: UIImage? = sfImage(.figureWalk)
    static let walkSelectedTabIcon: UIImage? = sfImage(.figureWalkMotion)
    static let diaryTabIcon: UIImage? = sfImage(.textBookClosed)
    static let diarySelectedTabIcon: UIImage? = sfImage(.textBookClosedFill)
    static let configTabIcon: UIImage? = sfImage(.gearshape)
    static let configSelectedTabIcon: UIImage? = sfImage(.gearshapeFill)
    
    static let takePhotoButtonIcon: UIImage? = sfImage(.cameraViewfinder)
    
    static let dateInfoIcon: UIImage? = sfImage(.calendar)
    static let temperatureInfoIcon: UIImage? = sfImage(.thermometerMedium)
    static let walkDistanceInfoIcon: UIImage? = sfImage(.figureWalk)
    static let walkTimeInfoIcon: UIImage? = sfImage(.clockFill)
    
    static let continueWritingConfigIcon: UIImage? = sfImage(.pencilLine)
    static let nearHomeConfigIcon: UIImage? = sfImage(.houseAndFlagFill)
    static let locationConfigIcon: UIImage? = sfImage(.locationFill)
    static let useCameraConfigIcon: UIImage? = sfImage(.cameraOnRectangleFill)
    static let usePhotoConfigIcon: UIImage? = sfImage(.photoFillOnRectangleFill)
    static let termsConfigIcon: UIImage? = sfImage(.docTextFill)
    static let licenseConfigIcon: UIImage? = sfImage(.buildingColumnsFill)
    static let sendToDeveloperConfigIcon: UIImage? = sfImage(.envelopeBadgePersonCropFill)
    static let deleteAllDiaryConfigIcon: UIImage? = sfImage(.trashFill)
    
    static let xmarkIcon: UIImage? = sfImage(.xmark)
  }
}
