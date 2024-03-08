//
//  PRLabel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit
import KazUtility

public final class PRLabel: UILabel {
  
  public init(style: Style, title: String? = nil) {
    super.init(frame: .zero)
    
    self.text = title
    
    switch style {
      case .mainTitle:
        self.configure {
          $0.font = PRAsset.Font.prMainTitleLabel
          $0.textColor = PRAsset.Color.prMainInfo
          $0.textAlignment = .natural
          $0.numberOfLines = 1
        }
        
      case .mainInfo:
        self.configure {
          $0.font = PRAsset.Font.prMainInfoLabel
          $0.textColor = PRAsset.Color.prMainInfo
          $0.textAlignment = .natural
          $0.numberOfLines = 1
        }
        
      case .subInfo:
        self.configure {
          $0.font = PRAsset.Font.prSubInfoLabel
          $0.textColor = PRAsset.Color.prSubInfo
          $0.textAlignment = .natural
          $0.numberOfLines = 0
        }
    }
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension PRLabel {
  
  enum Style {
    case mainTitle
    case mainInfo
    case subInfo
  }
}
