//
//  TimerManager.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation
import RxSwift

class TimerManager {
  var timer: Observable<TimeInterval>?
  var userDefinedTime =  Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)

  init() {
    let duration: DispatchTimeInterval = .seconds(Int(BTPreference.getInstance.userDefinedTimeInterval))

    timer = Observable<Int>
      .interval(.seconds(1), scheduler: MainScheduler.instance)
      .take(for: duration, scheduler: MainScheduler.instance)
      .map { _ in Date() }
      .map { self.userDefinedTime.timeIntervalSince($0)}
  }
}
