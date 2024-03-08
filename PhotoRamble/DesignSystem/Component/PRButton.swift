//
//  PRButton.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit
import KazUtility

public final class PRButton: UIButton {
  
  public init(style: Style, title: String? = nil, image: UIImage? = nil) {
    super.init(frame: .zero)
    
    self.configuration = style.configuration.configured {
      $0.title = title
      $0.image = image
    }
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension PRButton {
  
  enum Style {
    case primary
    case secondary
    case tertiary
    case tag
    
    private static let primaryConfig: UIButton.Configuration = .filled().configured {
      
      $0.baseForegroundColor = .white
      $0.baseBackgroundColor = PRAsset.Color.prPrimary
      $0.buttonSize = .large
      $0.cornerStyle = .medium
      $0.imagePadding = 10
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.configured { $0.font = PRAsset.Font.prPrimaryButtonTitle }
      }
    }
    
    private static let secondaryConfig: UIButton.Configuration = .filled().configured {
      
      $0.baseForegroundColor = PRAsset.Color.prPrimary
      $0.baseBackgroundColor = PRAsset.Color.prSecondary
      $0.buttonSize = .large
      $0.cornerStyle = .medium
      $0.imagePadding = 10
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.configured { $0.font = PRAsset.Font.prSecondaryButtonTitle }
      }
    }
    
    private static let tertiaryConfig: UIButton.Configuration = .plain().configured {
      
      $0.baseForegroundColor = PRAsset.Color.prPrimary
      $0.buttonSize = .large
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.configured { $0.font = PRAsset.Font.prTertiaryButtonTitle }
      }
    }
    
    private static let tagConfig: UIButton.Configuration = .filled().configured {
      
      $0.baseForegroundColor = PRAsset.Color.prPrimary
      $0.baseBackgroundColor = PRAsset.Color.prSecondary
      $0.buttonSize = .large
      $0.cornerStyle = .medium
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.configured { $0.font = PRAsset.Font.prTagButtonTitle }
      }
    }
    
    var configuration: UIButton.Configuration {
      switch self {
        case .primary:
          return Style.primaryConfig
        
        case .secondary:
          return Style.secondaryConfig
        
        case .tertiary:
          return Style.tertiaryConfig
        
        case .tag:
          return Style.tagConfig
      }
    }
  }
}

