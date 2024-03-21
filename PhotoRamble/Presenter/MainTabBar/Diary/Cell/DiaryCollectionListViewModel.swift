//
//  DiaryCollectionListViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DiaryCollectionListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let requestPhotoImagesEvent: PublishRelay<Diary>
  }
  
  struct Output {
    let photos: Driver<[Data]>
    let dateText: Driver<String>
    let contentText: Driver<String>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: DiaryCoordinator?
  private let fetchImageFileUsecase: any FetchImageFileUsecase
  
  // MARK: - Initializer
  init(fetchImageFileUsecase: some FetchImageFileUsecase) {
    self.fetchImageFileUsecase = fetchImageFileUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let photos = BehaviorRelay<[Data]>(value: [])
    
    let dateText = PublishRelay<String>()
    let contentText = PublishRelay<String>()
    
    input.requestPhotoImagesEvent
      .withUnretained(self)
      .do(onNext: { owner, diary in
        dateText.accept(DateManager.shared.toString(with: diary.createAt, format: .yyyyMMddEEEEKR))
        contentText.accept(diary.content)
      })
      .flatMap { owner, diary in
        return owner.fetchImageFileUsecase.execute(directoryName: diary.walkID.uuidString)
          .asObservable()
      }
      .bind(to: photos)
      .disposed(by: disposeBag)
    
    return Output(
      photos: photos.asDriver(),
      dateText: dateText.asDriver(onErrorJustReturn: ""),
      contentText: contentText.asDriver(onErrorJustReturn: "")
    )
  }
}
