//
//  ViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/7/24.
//

/*
import UIKit
import SnapKit

class ViewController: UIViewController {

  private lazy var stack = UIStackView().configured {
    $0.axis = .vertical
    
    $0.spacing = 16
    $0.addArrangedSubviews(
      primaryButton,
      secondaryButton,
      tertiaryButton,
      tagButton,
      selectedPhotoCountLabel,
      configTitleLabel,
      configInfoLabel,
      diaryTextView
    )
  }
  
  private let primaryButton = PRButton(style: .primary, title: "산책 완료")
  private let secondaryButton = PRButton(style: .secondary, title: "사진 찍기", image: PRAsset.Symbol.takePhotoButtonIcon)
  private let tertiaryButton = PRButton(style: .tertiary, title: "수정하기")
  private let tagButton = PRButton(style: .tag, title: "날짜순")
  
  private let selectedPhotoCountLabel = PRLabel(style: .mainInfo, title: "선택한 사진 3 / 10")
  private let configTitleLabel = PRLabel(style: .mainTitle, title: "위치 사용")
  private let configInfoLabel = PRLabel(style: .subInfo, title: "현재 날씨와 산책 경로를 만들 때 필요해요")
  
  private let diaryTextView = PRTextView(placeholder: "일기를 써주세요")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    view.addSubview(stack)
    
    stack.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    tagButton.snp.makeConstraints { make in
      make.width.equalTo(50)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  ViewController()
}
*/
