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
  var currentTime: PublishSubject<String> { get }
  var timer: Observable<Date> { get }
}

final class MainViewModel: MainViewModelType {
  init(_ notificationManager: NotificationManager,
       timerManager: TimerManager) {
    self.notificationManager = notificationManager
    self.timerManager = timerManager

    restartSubject
      .bind(onNext: refresh)
      .disposed(by: disposeBag)

    preferenceSubject
      .bind(onNext: edit)
      .disposed(by: disposeBag)

    PublishSubject<Int>
      .interval(1.0, scheduler: MainScheduler.instance)
      .map { _ in Date() }
      .map { self.userDefinedTime.timeIntervalSince($0) }
      .map { self.convertTimeInteger(with: $0) }
      .subscribe(onNext: { [weak self] dfds in
        print(dfds)
        self?.currentTime.onNext(dfds)
      })
      .disposed(by: disposeBag)

//    timer = PublishSubject<Int>
//      .interval(1.0, scheduler: MainScheduler.instance)
//      .map { _ in Date() }
  }

  var restartSubject = PublishSubject<Void>()
  var preferenceSubject = PublishSubject<Void>()
  var currentTime = PublishSubject<String>()
  var timer = Observable.just(Date())

  private let notificationManager: NotificationManager
  private let timerManager: TimerManager
  private let disposeBag = DisposeBag()

  var userDefinedTime =  Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
  func refresh() {
    userDefinedTime = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
//    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))
  }

  func edit() {
    let preferenceViewController = PreferenceController()
    let nav = UINavigationController(rootViewController: preferenceViewController)
//    self.present(nav, animated: true)
  }

  func fTimerAction(sender: Any?) {
//    guard let userDefinedTime = userDefinedTime else { return }

    let degree = userDefinedTime.timeIntervalSince(Date()) / BTPreference.getInstance.userDefinedTimeInterval * 360

//    arcView?.setCircularSector(degree: CGFloat(degree))
//    timerLabel.text = convertTimeInteger(with: userDefinedTime.timeIntervalSince(Date()))

    if Date() > userDefinedTime {
      completeTimer()
    }
  }

  func convertTimeInteger(with time: TimeInterval) -> String {
    let intTime = Int(time)
    let retValue = String(format: "%d:%02d", Int(intTime / 60), intTime % 60)
    return retValue
  }

  func completeTimer() {
    BTGlobalTimer.sharedInstance.stopTimer()
//    timerLabel.text = "Time out"
//    timerLabel.alpha = 1
//    restartButton.alpha = 1
//    preferenceButton.alpha = 1
  }
}
