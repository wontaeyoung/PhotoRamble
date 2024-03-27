//
//  NSCollectionLayoutSection+.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/12/24.
//

import UIKit

internal extension NSCollectionLayoutSection {
  
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
        heightDimension: .fractionalWidth(0.3)
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
  
  static func makeDynamicGridSection(
    itemCount: Int
  ) -> NSCollectionLayoutSection {
    let subItemCount: Int = min(
      itemCount - 1,
      BusinessValue.maxShowableCountInDiaryListCellSubGroup
    )
    
    switch subItemCount {
      case 0:
        let mainItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          )
        )

        let mainGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          ),
          subitems: [mainItem]
        )
        
        return NSCollectionLayoutSection(group: mainGroup)
        
      case 1:
        let mainItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
          )
        )

        let mainGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          ),
          subitem: mainItem,
          count: 2
        )
        
        return NSCollectionLayoutSection(group: mainGroup)
        
      default:
        let mainItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          )
        )

        let mainGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
          ),
          subitems: [mainItem]
        )
        
        let subItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          )
        )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
          ),
          subitem: subItem,
          count: 2
        )
        
        let subGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
          ),
          subitem: horizontalGroup,
          count: 2
        )
        
        let containerGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
          ),
          subitems: [mainGroup, subGroup]
        )
        
        return NSCollectionLayoutSection(group: containerGroup)
    }
    
    /*
    guard itemCount > 1 else {
      let mainItem = NSCollectionLayoutItem(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)
        )
      )

      let mainGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: .init(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)
        ),
        subitems: [mainItem]
      )
      
      return NSCollectionLayoutSection(group: mainGroup)
    }
    
    let mainItem = NSCollectionLayoutItem(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )

    let mainGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(0.5),
        heightDimension: .fractionalHeight(1)
      ),
      subitems: [mainItem]
    )
    
    let subGroup: NSCollectionLayoutGroup
    
    switch subItemCount {
      case 2:
        let subItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          )
        )
        
        subGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
          ),
          subitem: subItem,
          count: 2
        )
        
      case 3:
        let subItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          )
        )
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
          ),
          subitem: subItem,
          count: 1
        )
        
        let verticalGroup2 = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
          ),
          subitem: subItem,
          count: 2
        )
        
        subGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
          ),
          subitems: [verticalGroup, verticalGroup2]
        )
        
      default:
        let subItem = NSCollectionLayoutItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
          )
        )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
          ),
          subitem: subItem,
          count: 2
        )
        
        subGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: .init(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
          ),
          subitem: horizontalGroup,
          count: 2
        )
    }
    
    let containerGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(0.5)
      ),
      subitems: [mainGroup, subGroup]
    )
    
    return NSCollectionLayoutSection(group: containerGroup)
     */
  }
}
