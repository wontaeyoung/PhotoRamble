//
//  NSCollectionLayoutSection+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

public extension NSCollectionLayoutSection {
  
  static func makeCardSection(
    cardWidth: Double,
    cardHeight: NSCollectionLayoutDimension,
    cardSpacing: Double,
    scrollStyle: UICollectionLayoutSectionOrthogonalScrollingBehavior,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let cardItem: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    
    let cardGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(cardWidth),
        heightDimension: cardHeight
      ),
      subitems: [cardItem]
    )
    
    let section = NSCollectionLayoutSection(group: cardGroup)
    section.orthogonalScrollingBehavior = scrollStyle
    section.contentInsets = sectionInset
    section.interGroupSpacing = cardSpacing
    
    if header {
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
    }
    
    return section
  }
  
  static func makeListCardSection(
    cardListCount: Int,
    listSpacing: Double,
    cardWidth: Double,
    cardHeight: NSCollectionLayoutDimension,
    cardSpacing: Double,
    scrollStyle: UICollectionLayoutSectionOrthogonalScrollingBehavior,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let cardItem: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    
    let listGroup: NSCollectionLayoutGroup = .vertical(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      ),
      subitem: cardItem,
      count: cardListCount
    )
    listGroup.interItemSpacing = .fixed(listSpacing)
    
    let cardGroup: NSCollectionLayoutGroup = .horizontal(
      layoutSize: .init(
        widthDimension: .fractionalWidth(cardWidth),
        heightDimension: cardHeight
      ),
      subitems: [listGroup]
    )
    
    let section = NSCollectionLayoutSection(group: cardGroup)
    section.orthogonalScrollingBehavior = scrollStyle
    section.contentInsets = sectionInset
    section.interGroupSpacing = cardSpacing
    
    if header {
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
    }
    
    return section
  }
  
  static func makeGridListSection(
    gridCount: Int,
    gridSpacing: Double = 0,
    rowSpacing: Double = 0,
    scrollStyle: UICollectionLayoutSectionOrthogonalScrollingBehavior,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let gridWidthRatio = 1 / CGFloat(gridCount)
    
    let gridItem: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    let gridGroup: NSCollectionLayoutGroup = .horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(gridWidthRatio),
        heightDimension: .fractionalWidth(gridWidthRatio)
      ),
      subitems: [gridItem]
    )
    
    let rowGroup: NSCollectionLayoutGroup = .horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalWidth(gridWidthRatio)
      ),
      subitem: gridGroup,
      count: gridCount
    )
    
    rowGroup.interItemSpacing = .fixed(gridSpacing)
    
    let section = NSCollectionLayoutSection(group: rowGroup).configured {
      $0.orthogonalScrollingBehavior = scrollStyle
      $0.contentInsets = sectionInset
      $0.interGroupSpacing = rowSpacing
    }
    
    if header {
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
    }
    
    return section
  }
  
  static func makeHorizontalScrollSection(
    itemSpacing: Double = 0,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.3),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    let group: NSCollectionLayoutGroup = .horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      ),
      subitems: [item]
    )
    
    group.interItemSpacing = .fixed(itemSpacing)
    
    let section = NSCollectionLayoutSection(group: group).configured {
      $0.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
      $0.contentInsets = sectionInset
    }
    
    if header {
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
    }
    
    return section
  }
}
