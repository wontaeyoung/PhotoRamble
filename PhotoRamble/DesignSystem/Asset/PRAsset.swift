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
    
    public static let prPrimaryButtonTitle: UIFont = UIFont(name: FontName.bold.name, size: 19)
    public static let prSecondaryButtonTitle: UIFont = UIFont(name: FontName.semiBold.name, size: 19)
    public static let prMainTitleLabel: UIFont = UIFont(name: FontName.medium.name, size: 15)
    public static let prMainInfoLabel: UIFont = UIFont(name: FontName.semiBold.name, size: 15)
    public static let prSubInfoLabel: UIFont = UIFont(name: FontName.regular.name, size: 13)
    public static let prContentText: UIFont = UIFont(name: FontName.regular.name, size: 15)
  }
  
  public enum Symbol {
    
    private enum Image: String {
      
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
      
      var image: UIImage {
        return UIImage(systemName: self.rawValue)
      }
    }
    
    public static let walkTabIcon: UIImage = Image.figureWalk.image
    public static let diaryTabIcon: UIImage = Image.bookPagesFill.image
    public static let configTabIcon: UIImage = Image.gearshapeFill.image
    
    public static let takePhotoButtonIcon: UIImage = Image.cameraViewfinder.image
    
    public static let dateInfoIcon: UIImage = Image.calendar.image
    public static let temperatureInfoIcon: UIImage = Image.thermometerMedium.image
    public static let walkDistanceInfoIcon: UIImage = Image.figureWalk.image
    public static let walkTimeInfoIcon: UIImage = Image.clockFill.image
    
    public static let continueWritingConfigIcon: UIImage = Image.pencilLine.image
    public static let nearHomeConfigIcon: UIImage = Image.houseAndFlagFill.image
    public static let locationConfigIcon: UIImage = Image.locationFill.image
    public static let useCameraConfigIcon: UIImage = Image.cameraOnRectangleFill.image
    public static let usePhotoConfigIcon: UIImage = Image.photoFillOnRectangleFill.image
    public static let termsConfigIcon: UIImage = Image.docTextFill.image
    public static let licenseConfigIcon: UIImage = Image.buildingColumnsFill.image
    public static let sendToDeveloperConfigIcon: UIImage = Image.envelopeBadgePersonCropFill.image
    public static let deleteAllDiaryConfigIcon: UIImage = Image.trashFill.image
  }
}
