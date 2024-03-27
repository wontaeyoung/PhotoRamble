//
//  PRLabel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit

internal class PRLabel: UILabel {
  
  private let style: Style
  
  override internal var text: String? {
    didSet {
      if style == .diaryContent {
        applyLineSpacing()
      }
    }
  }
  
  internal init(style: Style, title: String? = nil, alignment: NSTextAlignment = .natural) {
    self.style = style
    
    super.init(frame: .zero)
    
    self.text = title
    self.textAlignment = alignment
    
    switch style {
      case .mainTitle:
        self.configure {
          $0.font = PRAsset.Font.prMainInfoLabel
          $0.textColor = PRAsset.Color.prMainInfo
          $0.numberOfLines = 1
        }
        
      case .timer:
        self.configure {
          $0.font = PRAsset.Font.prTimerLabel
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
        
      case .diaryContent:
        self.configure {
          $0.font = PRAsset.Font.prDiaryLabel
          $0.textColor = PRAsset.Color.prTitle
          $0.numberOfLines = 0
        }
    }
  }
  
  @available(*, unavailable)
  internal required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

internal extension PRLabel {
  
  enum Style {
    case mainTitle
    case timer
    case mainInfo
    case subInfo
    case content
    case navigationTitle
    case diaryContent
  }
  
  func applyLineSpacing() {
    guard let text = self.text else { return }
    
    let style = NSMutableParagraphStyle().configured {
      $0.lineSpacing = 10
    }
    
    self.attributedText = NSMutableAttributedString(string: text).configured {
      let range = NSRange(location: 0, length: $0.length)
      
      $0.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
      $0.addAttribute(NSAttributedString.Key.font, value: PRAsset.Font.prDiaryLabel, range: range)
    }
  }
}
