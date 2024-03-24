//
//  DiaryDetailViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FSPagerView

final class DiaryDetailViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let scrollView = UIScrollView()
  
  private let contentView = UIView()
  
  private lazy var photoPagerView = FSPagerView().configured {
    $0.isInfinite = true
    $0.delegate = self
    $0.dataSource = self
    $0.register(
      FSPagerViewCell.self,
      forCellWithReuseIdentifier: FSPagerViewCell.identifier
    )
  }
  
  private let pageControl = FSPageControl().configured {
    $0.numberOfPages = 3
    $0.contentHorizontalAlignment = .center
    $0.backgroundColor = PRAsset.Color.prBlack.withAlphaComponent(0.05)
  }
  
  private let dateImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.dateInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let walkTimeImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.walkTimeInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let dateLabel = PRLabel(style: .mainInfo)
  
  private let walkTimeLabel = PRLabel(style: .mainInfo)
  
  private let contentLabel = PRLabel(style: .diaryContent)
  
  // MARK: - Property
  let viewModel: DiaryDetailViewModel
  
  // MARK: - Initializer
  init(viewModel: DiaryDetailViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(scrollView)
    
    scrollView.addSubviews(contentView)
    
    contentView.addSubviews(
      photoPagerView,
      pageControl,
      dateImageView,
      walkTimeImageView,
      dateLabel,
      walkTimeLabel,
      contentLabel
    )
  }
  
  override func setConstraint() {
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints { make in
      make.verticalEdges.equalTo(scrollView)
      make.width.equalTo(scrollView)
    }
    
    photoPagerView.snp.makeConstraints { make in
      make.top.equalTo(contentView.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(contentView)
      make.height.equalTo(photoPagerView.snp.width)
    }
    
    pageControl.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(photoPagerView)
      make.bottom.equalTo(photoPagerView)
      make.height.equalTo(photoPagerView.snp.height).multipliedBy(0.1)
    }
    
    dateImageView.snp.makeConstraints { make in
      make.top.equalTo(photoPagerView.snp.bottom).offset(10)
      make.leading.equalTo(contentView).inset(20)
      make.size.equalTo(dateLabel.snp.height)
    }
    
    walkTimeImageView.snp.makeConstraints { make in
      make.top.equalTo(dateImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dateImageView)
      make.leading.equalTo(dateImageView.snp.trailing).offset(12)
      make.trailing.equalTo(contentView).inset(20)
    }
    
    walkTimeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(walkTimeImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(walkTimeImageView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(contentView).inset(20)
      make.bottom.equalTo(contentView).inset(20)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    dateLabel.text = "2024년 11월 25일 금요일"
    walkTimeLabel.text = "01시간 25분 32초"
    contentLabel.text = """
등 날리라 당번이, 계좌의 삼고 해소하다. 공약의 역시 이라 법률적 당면하다. 기술자다 보통은 나가다 민주화는 기근이 못한 대통령으로 터무니없다. 고려하다 개설에 선수의 시든다면 기법의 의하게 않아야, 변화를 있다. "데 대국을 회의는 촉구한, 세탁에, 알려지다 조직화도 계속 마음먹지 폭등하다" 기능공으로 감소는 장비가 앞길의 지방화를 가다. 공휴일이 장려한 기념사업이, 한창은 사고의 또는 필요한 동원으로 청산이 통하다.

부동산으로 오아 있고 동호회가 없애는 심리다 예비군에 교수의 시월일 정성이라고 어떻다. 기술은 당선되기, 중 사실이다 연초는 하다. 책의 서류에서 불로를 지지를 변화에 이상 된다. 여의 있다, 회장이 의미는 퇴임하다. "회사에 재활용품에서 개국, 발생량과 받아들이고자 어림잡다" 돋우어야 기지에 물러난지 조사는 하다. 투숙을 수익성으로 22일 교수 투입하다. 용감하고 것 한 군사력이 법인 변주곡은 모으고 아니라. 장관과 뒷받침되는 누구는 있은 한 중 사정이 30일, 보도한, 아니다.

반군과 이제 것 입건할 이면까지 처분하다. "독재로 권총인 발표로 싶어 하다" 최초와 생활을 정계를 지원만 및 아래로 없어라. 자유조차 7,980,000원 하게 협력을 수작으로 대선을 증가하고 벌지 비서관은 나선다 포함하다. 하늘빛의 기술은 강북부터 이후도 2024년 피해의, 위한다. 근절하는 추첨을 의거하여야 우리를 유행하라.
"""
  }
}

extension DiaryDetailViewController: FSPagerViewDelegate, FSPagerViewDataSource {
  func numberOfItems(in pagerView: FSPagerView) -> Int {
    return 3
  }
  
  func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.identifier, at: index)
    
    cell.imageView?.image = UIImage(systemName: "person.fill")
    
    return cell
  }
  
  func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    pageControl.currentPage = targetIndex
  }
}
