//
//  NumberFormatManager.swift
//  PhotoRamble
//
//  Created by 원태영 on 3/17/24.
//

import Foundation

final class NumberFormatManager {
  
  enum Unit: String {
    case km
    case MB
  }
  
  internal static let shared = NumberFormatManager()
  private init() { configFormatter() }
  
  // MARK: - Property
  private let formatter = NumberFormatter()

  // MARK: - Method
  private func configFormatter() {
    formatter.numberStyle = .decimal
    formatter.roundingMode = .halfUp
  }
  
  internal func toCurrency(from number: Int) -> String {
    return formatter.string(from: number as NSNumber) ?? String(number)
  }
  
  internal func toRounded(from number: Double, fractionDigits: Int) -> String {
    formatter.maximumFractionDigits = fractionDigits
    return formatter.string(from: number as NSNumber) ?? String(number)
  }
  
  internal func toRoundedWith(from number: Double, fractionDigits: Int, unit: Unit) -> String {
    formatter.maximumFractionDigits = fractionDigits
    let string = formatter.string(from: number as NSNumber) ?? String(number)
    
    return string + " " + unit.rawValue
  }
}
