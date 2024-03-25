//
//  SettingViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var settingListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  private let layout: UICollectionViewCompositionalLayout = .list(
    using: UICollectionLayoutListConfiguration(appearance: .grouped).applied {
      $0.showsSeparators = true
      $0.backgroundColor = PRAsset.Color.prBackground
      $0.headerMode = .supplementary
    }
  )
  
  // MARK: - Observable
  private let appVersion = BehaviorRelay<String>(value: "-")
  private let isCameraAuthorized = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Property
  let viewModel: SettingViewModel
  private var dataSource: UICollectionViewDiffableDataSource<SettingSection, SettingSection.Row>!
  
  // MARK: - Initializer
  init(viewModel: SettingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(settingListCollectionView)
  }
  
  override func setConstraint() {
    settingListCollectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func setAttribute() {
    setDataSource()
    updateSnapshot()
  }
  
  override func bind() {
    let input = SettingViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.appVersion
      .drive(appVersion)
      .disposed(by: disposeBag)
    
    output.isCameraAuthorized
      .drive(isCameraAuthorized)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(appVersion, isCameraAuthorized)
      .bind(with: self) { owner, str in
        owner.updateSnapshot()
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Method
  private func setDataSource() {
    let cellRegistration = makeCellRegistration()
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: settingListCollectionView) { collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: item
      )
    }
    
    let headerRegistration = makeHeaderRegistration()
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      return collectionView.dequeueConfiguredReusableSupplementary(
        using: headerRegistration,
        for: indexPath
      )
    }
  }
  
  private func makeHeaderRegistration() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
    .init(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
      supplementaryView.contentConfiguration = supplementaryView.defaultContentConfiguration().applied {
        $0.text = SettingSection(rawValue: indexPath.section)?.title
      }
    }
  }
  
  private func makeCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, SettingSection.Row> {
    return .init { [weak self] cell, indexPath, item in
      
      guard let self else { return }
      guard let section = SettingSection(rawValue: indexPath.section) else { return }
      let row = section.row(at: indexPath)
      
      cell.backgroundConfiguration = .listGroupedCell().applied {
        $0.backgroundColor = PRAsset.Color.prBackground
      }
      
      switch section {
        case .permission:
          cell.contentConfiguration = UIListContentConfiguration.subtitleCell().applied {
            $0.text = row.title
            $0.secondaryText = row.subTitle
            $0.image = row.icon
            
            $0.textProperties.apply {
              $0.color = PRAsset.Color.prPrimary
              $0.font = PRAsset.Font.prMainInfoLabel
            }
            
            $0.secondaryTextProperties.apply {
              $0.color = PRAsset.Color.prSubInfo
              $0.font = PRAsset.Font.prCaptionLabel
            }
          }
          
          cell.accessories = [
            .checkmark(options: .init(isHidden: !isCameraAuthorized.value))
          ]
          
        case .about:
          cell.contentConfiguration = UIListContentConfiguration.cell().applied {
            $0.text = row.title
            $0.image = row.icon
            
            switch row {
              case .clearDiary:
                $0.textProperties.apply {
                  $0.color = PRAsset.Color.prRed
                  $0.font = PRAsset.Font.prContentText
                }
                
                $0.imageProperties.apply {
                  $0.tintColor = PRAsset.Color.prRed
                }
                
              case .version:
                $0.textProperties.apply {
                  $0.color = PRAsset.Color.prPrimary
                  $0.font = PRAsset.Font.prMainInfoLabel
                }
                
                cell.accessories = [.label(text: self.appVersion.value)]
                
              default:
                $0.textProperties.apply {
                  $0.color = PRAsset.Color.prPrimary
                  $0.font = PRAsset.Font.prMainInfoLabel
                }
                
                cell.accessories = [.disclosureIndicator()]
            }
          }
      }
    }
  }
  
  private func updateSnapshot() {
    let snapshot = NSDiffableDataSourceSnapshot<SettingSection, SettingSection.Row>().applied { dataSource in
      SettingSection.allCases.forEach { section in
        dataSource.appendSections([section])
        dataSource.appendItems(section.rows, toSection: section)
      }
    }
    
    dataSource.apply(snapshot)
  }
}
