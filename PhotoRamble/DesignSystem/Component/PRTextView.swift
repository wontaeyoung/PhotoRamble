//
//  PRTextView.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

import UIKit
import SnapKit

public final class PRTextView: UITextView {
  
  public init(placeholder: String? = nil, isResponder: Bool = false) {
    super.init(frame: .zero, textContainer: nil)
    
    self.configure {
      $0.font = PRAsset.Font.prContentText
      $0.textColor = PRAsset.Color.prTitle
      $0.tintColor = PRAsset.Color.prPrimary
      $0.textAlignment = .natural
      $0.autocapitalizationType = .none
      $0.autocorrectionType = .no
      $0.spellCheckingType = .no
      $0.showsHorizontalScrollIndicator = false
      $0.showsVerticalScrollIndicator = false
      $0.addSubview(placeholderLabel)
      $0.delegate = $0
      
      if isResponder { $0.becomeFirstResponder() }
    }
    
    placeholderLabel.configure {
      $0.text = placeholder
      
      $0.snp.makeConstraints { make in
        make.top.equalTo(self).inset(textContainerInset.top)
        make.horizontalEdges.equalTo(self).inset(textContainerInset.top * 0.75)
        make.bottom.greaterThanOrEqualTo(self).inset(textContainerInset.bottom)
      }
    }
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var placeholderLabel = UILabel().configured {
    $0.font = self.font
    $0.textColor = PRAsset.Color.prPlaceholder
    $0.numberOfLines = 0
    $0.textAlignment = .natural
  }
}

extension PRTextView: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = !textView.text.isEmpty
  }
}
