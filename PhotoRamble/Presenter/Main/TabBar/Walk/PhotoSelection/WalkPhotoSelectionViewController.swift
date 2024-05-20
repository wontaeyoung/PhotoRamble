//
//  WalkPhotoSelectionViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast

final class WalkPhotoSelectionViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let photoInfoLabel = PRLabel(
    style: .subInfo,
    title: Localization.photo_selection_info_label.localized,
    alignment: .center
  )
  
  private lazy var takenPhotoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configured {
    $0.register(PhotoSelectionCollectionCell.self, forCellWithReuseIdentifier: PhotoSelectionCollectionCell.identifier)
    $0.backgroundColor = PRAsset.Color.prBackground
  }
  
  private let layout = UICollectionViewCompositionalLayout(
    section: .makeGridListSection(
      gridCount: BusinessValue.gridCountInPhotoSelectionRow,
      scrollStyle: .none
    )
  )
  
  private let photoSelectedCountInfoLabel = PRLabel(
    style: .mainTitle,
    title: Localization.photo_selected_count_info_label.localizedWith(0, BusinessValue.maxPhotoSelectionCount),
    alignment: .center
  )
  
  private let writeDiaryButton = PRButton(
    style: .primary,
    title: Localization.write_diary_button.localized
  )
  
  // MARK: - Property
  let viewModel: WalkPhotoSelectionViewModel
  private let photosRelay: BehaviorRelay<[UIImage]>
  private let selectedIndicesRelay = BehaviorRelay<[Int]>(value: [])
  
  // MARK: - Initializer
  init(viewModel: WalkPhotoSelectionViewModel, imageDataList: [Data]) {
    
    let images = imageDataList.compactMap {
      let newWidth = UIScreen.main.bounds.width / BusinessValue.gridCountInPhotoSelectionRow.cgFloat
      return UIImage(data: $0)?.resized(newWidth: newWidth)
    }
    
    self.viewModel = viewModel
    self.photosRelay = BehaviorRelay<[UIImage]>(value: images)
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      photoInfoLabel,
      takenPhotoCollectionView,
      photoSelectedCountInfoLabel,
      writeDiaryButton
    )
  }
  
  override func setConstraint() {
    photoInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    takenPhotoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(photoInfoLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view)
      make.bottom.equalTo(photoSelectedCountInfoLabel.snp.top).offset(-20)
    }
    
    photoSelectedCountInfoLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(writeDiaryButton.snp.top).offset(-20)
    }
    
    writeDiaryButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func bind() {
    let input = WalkPhotoSelectionViewModel.Input(
      writeDiaryButtonTapEvent: PublishRelay<Void>(),
      fixPhotoSelectionEvent: PublishRelay<[Data]>()
    )
    
    photosRelay
      .bind(
        to: takenPhotoCollectionView.rx.items(
          cellIdentifier: PhotoSelectionCollectionCell.identifier,
          cellType: PhotoSelectionCollectionCell.self)
      ) { [weak self] index, image, cell in
        guard let self else { return }
        cell.updateImage(with: image, selectedNumber: self.selectedNumber(at: index))
      }
      .disposed(by: disposeBag)
    
    selectedIndicesRelay
      .bind(with: self) { owner, _ in
        owner.updatePhotoCollection()
        owner.updateSelectedPhotoCount()
      }
      .disposed(by: disposeBag)
    
    takenPhotoCollectionView.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        let row = indexPath.row
        
        owner.updatePhotoIndices(with: row)
      }
      .disposed(by: disposeBag)
    
    writeDiaryButton.rx.tap
      .bind(to: input.writeDiaryButtonTapEvent)
      .disposed(by: disposeBag)
      
    let output = viewModel.transform(input: input)
    
    output.agreeDeleteUnselectedPhotoRelay
      .withLatestFrom(selectedIndicesRelay)
      .withUnretained(self)
      .flatMap { owner, indices in
        
        Observable.from(indices)
          .map { owner.photosRelay.value[$0] }
          .compactMap { $0.compressedJPEGData }
          .toArray()
      }
      .bind(to: input.fixPhotoSelectionEvent)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Method
  private func updatePhotoIndices(with photoIndex: Int) {
    if isSelected(with: photoIndex) {
      remove(at: photoIndex)
    } else {
      append(at: photoIndex)
    }
  }
  
  private func isSelected(with photoIndex: Int) -> Bool {
    selectedIndicesRelay.value.contains(photoIndex)
  }
  
  private func append(at photoIndex: Int) {
    guard selectedIndicesRelay.value.count < BusinessValue.maxPhotoSelectionCount else {
      let toastMessage = Localization.cannot_over_max_selection_alert.localizedWith(BusinessValue.maxPhotoSelectionCount)
      return view.makeToast(toastMessage, duration: 1, position: .center)
    }
    
    var mutableList = selectedIndicesRelay.value
    mutableList.append(photoIndex)
    selectedIndicesRelay.accept(mutableList)
  }
  
  private func remove(at photoIndex: Int) {
    guard let index = selectedIndicesRelay.value.firstIndex(of: photoIndex) else { return }
    
    var mutableList = selectedIndicesRelay.value
    mutableList.remove(at: index)
    selectedIndicesRelay.accept(mutableList)
  }
  
  private func selectedNumber(at photoIndex: Int) -> Int? {
    guard isSelected(with: photoIndex) else { return nil }
    guard let index = selectedIndicesRelay.value.firstIndex(of: photoIndex) else { return nil }
    
    return photoSelectionUINumber(with: index)
  }
  
  private func updatePhotoCollection() {
    takenPhotoCollectionView.reloadData()
  }
  
  private func updateSelectedPhotoCount() {
    let currentPhotoCount = selectedIndicesRelay.value.count
    
    photoSelectedCountInfoLabel.text = Localization.photo_selected_count_info_label.localizedWith(
      currentPhotoCount,
      BusinessValue.maxPhotoSelectionCount
    )
  }
  
  private func photoSelectionUINumber(with number: Int) -> Int {
    return number + 1
  }
}

extension WalkPhotoSelectionViewController: UICollectionViewDelegate {
  
  enum CollectionSection: Int, CaseIterable, Hashable {
    case main
  }
}
