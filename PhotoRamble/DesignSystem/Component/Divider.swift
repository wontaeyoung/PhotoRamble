//
//  Divider.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/22/24.
//

import UIKit
import SnapKit

final class Divider: UIView {
  
  init(color: UIColor) {
    super.init(frame: .zero)
    
    self.backgroundColor = color
    
    self.snp.makeConstraints { make in
      make.height.equalTo(1)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
