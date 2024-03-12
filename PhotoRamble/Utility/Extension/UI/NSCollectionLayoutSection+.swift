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
}
