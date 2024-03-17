//
//  WriteDiaryViewModel.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class WriteDiaryViewModel: ViewModel {
  
  enum WritingStyle {
    case initial(distance: Double, interval: TimeInterval)
    case modify(date: Date, temperature: Int, distance: Double, interval: TimeInterval)
  }
  
  // MARK: - I / O
  struct Input {
    let diaryText: PublishSubject<String>
    let writingCompletedButtonTapEvent: PublishRelay<(diaryText: String, photoIndices: [Int])>
  }
  
  struct Output {
    let dateText: Signal<String>
    let temperatureText: Signal<String>
    let walkDistanceText: Signal<String>
    let walkTimeInterval: Signal<String>
    let isCompleteButtonEnabled: Signal<Bool>
  }
  
  // MARK: - Observable
  private let walkRelay: BehaviorRelay<Walk>
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: WalkCoordinator?
  
  private let date: Date
  private let temperature: Int
  private let walkDistance: Double
  private let walkTimeInterval: TimeInterval
  
  // MARK: - Initializer
  init(style: WritingStyle, walk: Walk) {
    switch style {
      case let .initial(distance, interval):
        self.date = .now
        self.temperature = 0
        self.walkDistance = distance
        self.walkTimeInterval = interval
        
      case let .modify(date, temperature, distance, interval):
        self.date = date
        self.temperature = temperature
        self.walkDistance = distance
        self.walkTimeInterval = interval
    }
    
    self.walkRelay = .init(value: walk)
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
      
    let dateText: Signal<String> = Observable.just(DateManager.shared.toString(with: date, format: .yyyyMMddEEEEKR))
      .asSignal(onErrorJustReturn: "-")
    
    let temeratureText: Signal<String> = Observable.just("\(temperature) °")
      .asSignal(onErrorJustReturn: "0 °")
    
    let walkDistanceText: Signal<String> = Observable.just(NumberFormatManager.shared.toRoundedWith(from: walkDistance, fractionDigits: 2, unit: .km))
      .asSignal(onErrorJustReturn: "0.0 km")
    
    let walkTimeInterval: Signal<String> = Observable.just(DateManager.shared.toString(with: walkTimeInterval, format: .HHmmssKR))
      .asSignal(onErrorJustReturn: DateManager.shared.toString(with: 0, format: .HHmmssKR))
    
    let isCompleteButtonEnabled: Signal<Bool> = input.diaryText
      .map { !$0.isEmpty }
      .asSignal(onErrorJustReturn: false)
    
    return Output(
      dateText: dateText,
      temperatureText: temeratureText,
      walkDistanceText: walkDistanceText,
      walkTimeInterval: walkTimeInterval,
      isCompleteButtonEnabled: isCompleteButtonEnabled
    )
  }
}
