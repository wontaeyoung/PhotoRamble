//
//  WalkPhotoSelectionViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WalkPhotoSelectionViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let writeDiaryButtonTapEvent: PublishRelay<Void>
    let fixPhotoSelectionEvent: PublishRelay<[Data]>
  }
  
  struct Output {
    let agreeDeleteUnselectedPhotoRelay: PublishRelay<Void>
  }
  
  // MARK: - Observable
  private let walkRelay: BehaviorRelay<Walk>
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  private let replaceImageFileUsecase: any ReplaceImageFileUsecase
  private let createWalkUsecase: any CreateWalkUsecase
  
  // MARK: - Initializer
  init(
    walkRelay: BehaviorRelay<Walk>,
    replaceImageFileUsecase: some ReplaceImageFileUsecase,
    createWalkUsecase: some CreateWalkUsecase
  ) {
    self.walkRelay = walkRelay
    self.replaceImageFileUsecase = replaceImageFileUsecase
    self.createWalkUsecase = createWalkUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let agreeDeleteUnselectedPhotoRelay = PublishRelay<Void>()
    
    input.writeDiaryButtonTapEvent
      .bind(with: self, onNext: { owner, _ in
        
        owner.coordinator?.showAlert(
          title: "사진 선택 안내",
          message: "선택하지 않은 나머지 사진은 삭제돼요. 정말 이 사진들로 선택하시겠어요?",
          okStyle: .destructive,
          isCancelable: true
        ) {
          agreeDeleteUnselectedPhotoRelay.accept(())
        }
      })
      .disposed(by: disposeBag)
    
    input.fixPhotoSelectionEvent
      .withUnretained(self)
      .flatMap { owner, imageDataList in
        owner.replaceImageFileUsecase
          .execute(imageDataList: imageDataList, directoryName: owner.walkRelay.value.id.uuidString)
          .asObservable()
      }
      .withUnretained(self)
      .flatMap { owner, imageDataList in
        let initialDiary = owner.makeInitialDiary(photoIndices: imageDataList.indices)
        owner.prepareWalkForNextFlow(diaryID: initialDiary.id)
        
        return Observable.just((initialDiary, imageDataList))
      }
      .withUnretained(self)
      .flatMap { owner, result in
        let createWalk = owner.createWalkUsecase.execute(with: owner.walkRelay.value)
        let (diary, imageDataList) = result
        
        return createWalk.map { walk in (walk, diary, imageDataList) }
      }
      .subscribe(with: self, onNext: { owner, result in
        let (walk, diary, dataList) = result
        
        owner.coordinator?.showWriteDiaryView(
          walk: walk,
          diary: diary,
          imageDataList: dataList
        )
      }, onError: { owner, error in
        // FIXME: 여기서 Replace 과정에서 일어난 삭제 데이터 복구 과정 필요함
      })
      .disposed(by: disposeBag)
    
    return Output(agreeDeleteUnselectedPhotoRelay: agreeDeleteUnselectedPhotoRelay)
  }
  
  private func makeInitialDiary(photoIndices: Range<Int>) -> Diary {
    return .initialDiary(
      photoIndicies: photoIndices.map { $0 },
      walkID: walkRelay.value.id
    )
  }
  
  private func prepareWalkForNextFlow(diaryID: UUID) {
    var updatedWalk = walkRelay.value.applied { $0.diaryID = diaryID }
    walkRelay.accept(updatedWalk)
  }
}
