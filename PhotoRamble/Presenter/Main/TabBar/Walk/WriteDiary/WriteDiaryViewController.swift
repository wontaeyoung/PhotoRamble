//
//  WriteDiaryViewController.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WriteDiaryViewController: RXBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).configured {
    $0.register(DiaryPhotoCollectionCell.self, forCellWithReuseIdentifier: DiaryPhotoCollectionCell.identifier)
    $0.showsHorizontalScrollIndicator = false
    $0.keyboardDismissMode = .onDrag
    $0.backgroundColor = PRAsset.Color.prBackground
  }
  
  private let noPhotoInfoLabel = PRLabel(style: .subInfo, title: "선택된 사진이 없어요.", alignment: .center)
  
  private var layout: UICollectionViewFlowLayout {
    let cellCount: CGFloat = BusinessValue.gridCountInDiaryPhotoHorizontalRow.cgFloat
    let cellSpacing: CGFloat = 20
    let cellWidth: CGFloat = (UIScreen.main.bounds.width - (cellSpacing * (2 + cellCount - 1))) / cellCount
    
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = CGSize(width: cellWidth, height: cellWidth)
      $0.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
      $0.minimumInteritemSpacing = cellSpacing
      $0.scrollDirection = .horizontal
    }
  }
  
  private let dateImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.dateInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  /* ver. 1.0 이후 업데이트 사항으로 아카이브 처리
  private let weatherImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.temperatureInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let walkDistanceImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.walkDistanceInfoIcon
    $0.contentMode = .scaleAspectFit
  }
   */
  
  private let walkTimeImageView = UIImageView().configured {
    $0.image = PRAsset.Symbol.walkTimeInfoIcon
    $0.contentMode = .scaleAspectFit
  }
  
  private let dateLabel = PRLabel(style: .mainInfo)
  
  /* ver. 1.0 이후 업데이트 사항으로 아카이브 처리
  private let weatherLabel = PRLabel(style: .mainInfo)
  private let walkDistanceLabel = PRLabel(style: .mainInfo)
   */
  
  private let walkTimeLabel = PRLabel(style: .mainInfo)
  
  private lazy var diaryTextView = PRTextView(placeholder: "일기 내용을 써주세요").configured { textView in
    textView.backgroundColor = PRAsset.Color.prBackground
    textView.inputAccessoryView = UIToolbar().configured {
      let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let doneButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down.fill"), style: .done, target: self, action: nil)
      $0.setItems([flexibleSpace, doneButton], animated: false)
      $0.sizeToFit()
      
      doneButton.rx.tap
        .bind(with: self) { owner, _ in
          textView.resignFirstResponder()
        }
        .disposed(by: self.disposeBag)
    }
  }
  
  private let writingCompletedButton = PRButton(style: .primary, title: "다 썼어요")
  
  // MARK: - Observable
  private let photosRelay: BehaviorRelay<[UIImage]>
  private let deletePhotoButtonTapEvent = PublishRelay<Int>()
  
  // MARK: - Property
  let viewModel: WriteDiaryViewModel
  
  // MARK: - Initializer
  init(viewModel: WriteDiaryViewModel, style: WriteDiaryViewModel.WritingStyle, imageDataList: [Data]) {
    let photos = imageDataList.compactMap { UIImage(data: $0) }
    self.photosRelay = .init(value: photos)
    self.viewModel = viewModel
    
    super.init()
    
    self.setNavigationTitle(with: style.navigationTitle, displayMode: .never)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      photoCollectionView,
      noPhotoInfoLabel,
      dateImageView,
      /* ver. 1.0 이후 업데이트 사항으로 아카이브 처리
      weatherImageView,
      walkDistanceImageView,
       */
      walkTimeImageView,
      dateLabel,
      /* ver. 1.0 이후 업데이트 사항으로 아카이브 처리
      weatherLabel,
      walkDistanceLabel,
       */
      walkTimeLabel,
      diaryTextView,
      writingCompletedButton
    )
  }
  
  override func setConstraint() {
    photoCollectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view)
      make.height.equalTo(150)
    }
    
    noPhotoInfoLabel.snp.makeConstraints { make in
      make.edges.equalTo(photoCollectionView).inset(20)
    }
    
    dateImageView.snp.makeConstraints { make in
      make.top.equalTo(photoCollectionView.snp.bottom)
      make.leading.equalTo(view).inset(20)
      make.size.equalTo(dateLabel.snp.height)
    }
    
    /* ver. 1.0 이후 업데이트 사항으로 아카이브 처리
    weatherImageView.snp.makeConstraints { make in
      make.top.equalTo(dateImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    walkDistanceImageView.snp.makeConstraints { make in
      make.top.equalTo(weatherImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
     */
    
    walkTimeImageView.snp.makeConstraints { make in
      make.top.equalTo(dateImageView.snp.bottom).offset(12)
      make.leading.equalTo(dateImageView)
      make.size.equalTo(dateImageView)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.centerY.equalTo(dateImageView)
      make.leading.equalTo(dateImageView.snp.trailing).offset(12)
      make.trailing.equalTo(view).inset(20)
    }
    
    /* ver. 1.0 이후 업데이트 사항으로 아카이브 처리
    weatherLabel.snp.makeConstraints { make in
      make.centerY.equalTo(weatherImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    walkDistanceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(walkDistanceImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
     */
    
    walkTimeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(walkTimeImageView)
      make.horizontalEdges.equalTo(dateLabel)
    }
    
    diaryTextView.snp.makeConstraints { make in
      make.top.equalTo(walkTimeImageView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(writingCompletedButton.snp.top).offset(-20)
    }
    
    writingCompletedButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = WriteDiaryViewModel.Input(
      diaryText: .init(), 
      photoDeletedEvent: .init(),
      writingCompletedButtonTapEvent: .init(),
      cratedDiaryToastCompletedEvent: .init()
    )
    
    photosRelay
      .do(onNext: { _ in
        self.toggleNoPhotoInfoLabelVisible()
      })
      .bind(
        to: photoCollectionView.rx.items(
          cellIdentifier: DiaryPhotoCollectionCell.identifier,
          cellType: DiaryPhotoCollectionCell.self)
      ) { [weak self] index, image, cell in
        guard let self else { return }
        cell.updateImage(with: image, at: index, tapEventRelay: deletePhotoButtonTapEvent)
      }
      .disposed(by: disposeBag)
    
    deletePhotoButtonTapEvent
      .bind(with: self, onNext: { owner, index in
        input.photoDeletedEvent.accept(index)
      })
      .disposed(by: disposeBag)
    
    writingCompletedButton.rx.tap
      .throttle(.seconds(5), scheduler: MainScheduler.instance)
      .withUnretained(self) { owner, _ in
        if #available(iOS 16, *) { owner.showWritingIndicator() }
      }
      .bind(to: input.writingCompletedButtonTapEvent)
      .disposed(by: disposeBag)
    
    let output = viewModel.transform(input: input)
    
    output.dateText
      .emit(to: dateLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.walkTimeInterval
      .emit(to: walkTimeLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.deleteCompleted
      .emit(with: self) { owner, index in
        owner.deletePhoto(at: index)
      }
      .disposed(by: disposeBag)
    
    output.isCompleteButtonEnabled
      .emit(to: writingCompletedButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    output.showCreatedDiaryToast
      .emit(with: self) { owner, _ in
        owner.view.makeToast("일기가 작성되었어요.", duration: 1, position: .center) { _ in
          input.cratedDiaryToastCompletedEvent.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    diaryTextView.rx.text.orEmpty
      .bind(to: input.diaryText)
      .disposed(by: disposeBag)
    
    let tap = UITapGestureRecognizer()
    view.addGestureRecognizer(tap)
    
    tap.rx.event
      .bind(with: self) { owner, _ in
        owner.view.endEditing(true)
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Method
  private func deletePhoto(at index: Int) {
    let updatedPhotos = photosRelay.value.removed(at: index)
    photosRelay.accept(updatedPhotos)
  }
  
  private func toggleNoPhotoInfoLabelVisible() {
    noPhotoInfoLabel.isHidden = !photosRelay.value.isEmpty
  }
  
  @available(iOS 16, *)
  private func showWritingIndicator() {
    writingCompletedButton.configuration?.apply {
      $0.showsActivityIndicator = true
    }
  }
  
  @available(iOS 16, *)
  private func hideWritingIndicator() {
    writingCompletedButton.configuration?.apply {
      $0.showsActivityIndicator = false
    }
  }
}
