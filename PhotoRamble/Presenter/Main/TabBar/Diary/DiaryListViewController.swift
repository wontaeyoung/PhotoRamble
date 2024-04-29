//
//  DiaryListViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DiaryListViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var diaryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configured {
    $0.backgroundColor = PRAsset.Color.prBackground
    $0.delegate = self
  }
  
  private let layout = UICollectionViewFlowLayout().configured {
    let cellSpacing: CGFloat = 20
    $0.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    $0.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
    $0.minimumLineSpacing = 50
    $0.minimumInteritemSpacing = 50
  }
  
  private let noDiaryInfoLabel = PRLabel(style: .subInfo, title: "작성된 일기가 아직 없어요.\n동네를 산책하고 첫 일기를 작성해보는 것은 어떨까요?", alignment: .center)
  
  // MARK: - Property
  let viewModel: DiaryListViewModel
  private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>!
  
  // MARK: - Initializer
  init(viewModel: DiaryListViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      diaryListCollectionView,
      noDiaryInfoLabel
    )
  }
  
  override func setConstraint() {
    diaryListCollectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    noDiaryInfoLabel.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func setAttribute() {
    setDataSource()
  }
  
  override func bind() {
    let input = DiaryListViewModel.Input(
      viewDidLoadEvent: PublishRelay(),
      diaryCellTapEvent: PublishRelay()
    )
    
    let output = viewModel.transform(input: input)
    
    diaryListCollectionView.rx.itemSelected
      .do(onNext: {
        self.diaryListCollectionView.deselectItem(at: $0, animated: true)
      })
      .bind(to: input.diaryCellTapEvent)
      .disposed(by: disposeBag)
    
    output.diaries
      .drive(with: self) { owner, diaries in
        owner.updateSnapshot(diaries: diaries)
        owner.resetCollectionScrollOffset()
        owner.toggleNoDiaryInfoLabelVisibility(isEmpty: diaries.isEmpty)
      }
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
}

// MARK: - Collection Configuration
extension DiaryListViewController: UICollectionViewDelegate {
  
  enum Section: CaseIterable {
    case main
  }
  
  private func setDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<DiaryCollectionListCell, Diary> { cell, indexPath, item in
      
      cell.bind(diary: item)
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: diaryListCollectionView) { collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: item
      )
    }
  }
  
  private func updateSnapshot(diaries: [Diary]) {
    let snapshot = NSDiffableDataSourceSnapshot<Section, Diary>().applied {
      $0.appendSections(Section.allCases)
      $0.appendItems(diaries)
    }
    
    dataSource.apply(snapshot)
  }
  
  private func resetCollectionScrollOffset() {
    diaryListCollectionView.setContentOffset(.zero, animated: true)
  }
  
  private func toggleNoDiaryInfoLabelVisibility(isEmpty: Bool) {
    noDiaryInfoLabel.isHidden = !isEmpty
  }
}
