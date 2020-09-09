//
//  MainViewModel.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol MainViewModelType: class {
  var restartSubject: PublishSubject<Void> { get }
  var preferenceSubject: PublishSubject<Void> { get }

  var currentTime: ReplaySubject<String> { get }
  var timeDegree: BehaviorSubject<CGFloat> { get }
}

final class MainViewModel: MainViewModelType, ObservableObject {

  init(_ notificationManager: NotificationManager,
       timerManager: TimerManager,
       navigationDelegate: NavigationDelegate?) {
    self.notificationManager = notificationManager
    self.timerManager = timerManager
    self.navigationDelegate = navigationDelegate

    restartSubject
      .bind(onNext: refresh)
      .disposed(by: disposeBag)

//    preferenceSubject
//        .bind(onNext: navigationDelegate?.preferenceButtonSelected)
//      .disposed(by: disposeBag)

    timerManager.timer?
      .map { timeInterval in self.convertTimeInteger(with: timeInterval + 1) }
      .subscribe(
        onNext: { [weak self] timeString in
          self?.currentTime.onNext(timeString)
        },
        onCompleted: { [weak self] in
          self?.currentTime.onNext("00:00")
        })
      .disposed(by: disposeBag)

    timerManager.timer?
      .map { CGFloat($0 / BTPreference.getInstance.userDefinedTimeInterval * 360) }
      .subscribe(
        onNext: { [weak self] in
          self?.timeDegree.onNext($0)
        },
        onCompleted: { [weak self] in
          self?.timeDegree.onNext(0.0)
        })
      .disposed(by: disposeBag)

    currentTime.onNext(convertTimeInteger(with: BTPreference.getInstance.userDefinedTimeInterval))

    let date = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
    notificationManager.registerNotification(date: date)
  }

  var restartSubject = PublishSubject<Void>()
  var preferenceSubject = PublishSubject<Void>()
  var currentTime = ReplaySubject<String>.create(bufferSize: 1)
  var timeDegree = BehaviorSubject<CGFloat>(value: 0.0)

  private let notificationManager: NotificationManager
  private let timerManager: TimerManager
  private let navigationDelegate: NavigationDelegate?
  private let disposeBag = DisposeBag()

  func refresh() {
    timerManager.userDefinedTime = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
  }

  private func convertTimeInteger(with time: TimeInterval) -> String {
    let intTime = Int(time)
    let retValue = String(format: "%d:%02d", Int(intTime / 60), intTime % 60)
    return retValue
  }
}
