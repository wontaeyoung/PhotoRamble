//
//  SettingWebViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/26/24.
//

import UIKit
import WebKit
import SnapKit
import RxSwift
import RxCocoa

enum SettingWebCase {
  
  case privacy
  case openSource
  
  var navigationTitle: String {
    switch self {
      case .privacy:
        return "개인정보 처리 방침"
      
      case .openSource:
        return "오픈소스 라이선스"
    }
  }
  
  var request: URLRequest? {
    switch self {
      case .privacy:
        guard let url = URL(string: "https://bit.ly/4csOVkv") else { return nil }
        return URLRequest(url: url)
      
      case .openSource:
        guard let url = URL(string: "https://bit.ly/3TwtNRJ") else { return nil }
        return URLRequest(url: url)
    }
  }
}

final class SettingWebViewController: RXBaseViewController {
  
  // MARK: - UI
  private let webView = WKWebView().configured {
    $0.backgroundColor = PRAsset.Color.prBackground
    $0.scrollView.backgroundColor = PRAsset.Color.prBackground
  }
  
  // MARK: - Property
  
  
  // MARK: - Initializer
  init(webCase: SettingWebCase) {
    if let request = webCase.request {
      webView.load(request)
    }
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(webView)
  }
  
  override func setConstraint() {
    webView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
