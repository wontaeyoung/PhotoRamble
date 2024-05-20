//
//  SplashViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    
    init(viewDidLoadEvent: PublishRelay<Void> = .init()) {
      self.viewDidLoadEvent = viewDidLoadEvent
    }
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: SplashCoordinator?
  private let appInfoRepository: AppInfoRepository
  
  // MARK: - Initializer
  init(appInfoRepository: AppInfoRepository) {
    self.appInfoRepository = appInfoRepository
  }
  
  // MARK: - Method
  @discardableResult
  func transform(input: Input) -> Output {
  
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.appInfoRepository.fetchNewVersionAvailable()
          .catch { error in
            return .just(false)
          }
      }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isNewVersionAvailable in
        if isNewVersionAvailable {
          owner.promptForUpdate() 
        } else {
          owner.connectMainTabBarFlow()
        }
      }
      .disposed(by: disposeBag)
    
    return Output()
  }
  
  private func promptForUpdate() {
    coordinator?.showAlert(
      title: "최신 버전 업데이트 안내",
      message: "앱스토어에 업데이트 가능한 최신 버전이 있습니다. 원활한 사용을 위해 앱을 업데이트해주세요.\n확인을 누르면 앱스토어로 이동합니다."
    ) { [weak self] in
      guard let self else { return }
      
      guard let url = URL(string: "itms-apps://itunes.apple.com/app/6479728861"),
            UIApplication.shared.canOpenURL(url)
      else {
        coordinator?.showAlert(
          title: "앱스토어 연결 실패",
          message: "앱스토어를 연결하지 못했어요. 확인을 누르면 메인 화면으로 이동해요."
        ) {
          self.connectMainTabBarFlow()
        }
        
        return 
      }
      
      UIApplication.shared.open(url)
    }
  }
  
  private func connectMainTabBarFlow() {
    coordinator?.connectMainTabBarFlow()
  }
}
