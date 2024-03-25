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
    }
  )
  
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
    
  }
  
  // MARK: - Method
  private func setDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingSection.Row> { cell, indexPath, item in
      
      guard let section = SettingSection(rawValue: indexPath.section) else { return }
      let row = section.row(at: indexPath)
      
      switch section {
        case .access:
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
          
          cell.accessories = [.checkmark()]
          
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
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: settingListCollectionView) { collectionView, indexPath, item in
      return collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: item
      )
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