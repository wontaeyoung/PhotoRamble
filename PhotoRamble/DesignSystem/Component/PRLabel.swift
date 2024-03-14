//
//  PRLabel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit

public final class PRLabel: UILabel {
  
  public init(style: Style, title: String? = nil, alignment: NSTextAlignment = .natural) {
    super.init(frame: .zero)
    
    self.text = title
    self.textAlignment = textAlignment
    
    switch style {
      case .mainTitle:
        self.configure {
          $0.font = PRAsset.Font.prMainTitleLabel
          $0.textColor = PRAsset.Color.prMainInfo
          $0.numberOfLines = 1
        }
        
      case .mainInfo:
        self.configure {
          $0.font = PRAsset.Font.prMainInfoLabel
          $0.textColor = PRAsset.Color.prMainInfo
          $0.numberOfLines = 1
        }
        
      case .subInfo:
        self.configure {
          $0.font = PRAsset.Font.prSubInfoLabel
          $0.textColor = PRAsset.Color.prSubInfo
          $0.numberOfLines = 0
        }
        
      case .content:
        self.configure {
          $0.font = PRAsset.Font.prSubInfoLabel
          $0.textColor = PRAsset.Color.prTitle
          $0.numberOfLines = 0
        }
        
      case .navigationTitle:
        self.configure {
          $0.font = PRAsset.Font.prNavigationTitleLabel
          $0.textColor = PRAsset.Color.prTitle
          $0.numberOfLines = 2
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
    case content
    case navigationTitle
  }
}
