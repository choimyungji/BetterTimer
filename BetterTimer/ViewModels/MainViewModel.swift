//
//  MainViewModel.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation
//import Combine

//import RxCocoa
//import RxSwift
//
//protocol MainViewModelType: AnyObject {
//    var restartSubject: PublishSubject<Void> { get }
//    var preferenceSubject: PublishSubject<Void> { get }
//
//    var currentTime: ReplaySubject<String> { get }
//    var timeDegree: BehaviorSubject<CGFloat> { get }
//}

final class MainViewModel: ObservableObject {

  init(_ notificationManager: NotificationManager,
       timerManager: TimerManager,
       navigationDelegate: NavigationDelegate?) {
    self.notificationManager = notificationManager
    self.timerManager = timerManager
    self.navigationDelegate = navigationDelegate

    let date = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
    notificationManager.registerNotification(date: date)
  }

//    var restartSubject = PassthroughSubject<Void, Error>()
//    var preferenceSubject = PassthroughSubject<Void, Error>()
//    var currentTime = ReplaySubject<String>.create(bufferSize: 1)
//    var timeDegree = BehaviorSubject<CGFloat>(value: 0.0)

  private let notificationManager: NotificationManager
  private let timerManager: TimerManager
  private weak var navigationDelegate: NavigationDelegate?

  func refresh() {
    timerManager.userDefinedTime = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
  }

  private func convertTimeInteger(with time: TimeInterval) -> String {
    let intTime = Int(time)
    let retValue = String(format: "%d:%02d", Int(intTime / 60), intTime % 60)
    return retValue
  }
}
