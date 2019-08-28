//
//  ViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 31/01/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit
import UserNotifications

class MainController: UIViewController {
  var userDefinedTime: Date?
  let defaultMargin: CGFloat = 24
  var isShownViewComponent: Bool = true

  var statusBarHidden = false {
    didSet {
      UIView.animate(withDuration: 2) {
        self.setNeedsStatusBarAppearanceUpdate()
      }
    }
  }

  var arcView: MainArcView?
  private lazy var timerLabel = UILabel().then {
    $0.textColor = .red
    $0.font = UIFont.systemFont(ofSize: 40, weight: .ultraLight)
    $0.textAlignment = .center
  }

  private lazy var restartButton = UIButton().then {
    $0.setTitle("Refresh", for: .normal)
    $0.setTitleColor(.red, for: .normal)
    $0.addTarget(self, action: #selector(refresh), for: .touchUpInside)
  }

  private lazy var preferenceButton = UIButton().then {
    $0.setTitle("Edit", for: .normal)
    $0.setTitleColor(.red, for: .normal)
    $0.addTarget(self, action: #selector(edit), for: .touchUpInside)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animateKeyframes(withDuration: 6,
                            delay: 0,
                            options: .calculationModeCubic,
                            animations: {
        UIView.addKeyframe(withRelativeStartTime: 0,
                           relativeDuration: 1.0 / 6.0) {
                            self.timerLabel.alpha = 1
                            self.restartButton.alpha = 1
                            self.preferenceButton.alpha = 1
                            self.statusBarHidden = false
        }

        UIView.addKeyframe(withRelativeStartTime: 2.0 / 6.0,
                           relativeDuration: 4.0 / 6.0) {
                            self.timerLabel.alpha = 0
                            self.restartButton.alpha = 0
                            self.preferenceButton.alpha = 0
                            self.statusBarHidden = true
        }
    })
  }

  @objc func refresh() {
    userDefinedTime = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))
  }

  @objc func edit() {
    let preferenceViewController = PreferenceController()
    let nav = UINavigationController(rootViewController: preferenceViewController)
    self.present(nav, animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPosition = UIScreen.main.bounds.height - 220
    timerLabel.frame = CGRect(x: defaultMargin, y: yPosition, width: line, height: 30)
    view.addSubview(timerLabel)
    timerLabel.text = convertTimeInteger(with: BTPreference.getInstance.userDefinedTimeInterval)

    restartButton.frame = CGRect(x: defaultMargin, y: yPosition + 40, width: line, height: 30)
    preferenceButton.frame = CGRect(x: defaultMargin,
                                    y: UIScreen.main.bounds.height - 44,
                                    width: 60,
                                    height: 44)
    view.addSubview(restartButton)
    view.addSubview(preferenceButton)
  }

  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 4) {
      self.timerLabel.alpha = 0
      self.restartButton.alpha = 0
      self.preferenceButton.alpha = 0
    }
    userDefinedTime = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)

    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))
    registerNotification()

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPostion = (UIScreen.main.bounds.height - line) / 2

    arcView = MainArcView(frame: CGRect(x: defaultMargin, y: yPostion, width: line, height: line))
    view.addSubview(arcView!)
    statusBarHidden = true
  }

  @objc func fTimerAction(sender: Any?) {
    guard let userDefinedTime = userDefinedTime else { return }

    let degree = userDefinedTime.timeIntervalSince(Date()) / BTPreference.getInstance.userDefinedTimeInterval * 360

    arcView?.setCircularSector(degree: CGFloat(degree))
    timerLabel.text = convertTimeInteger(with: userDefinedTime.timeIntervalSince(Date()))

    if Date() > userDefinedTime {
      completeTimer()
    }
  }

  func convertTimeInteger(with time: TimeInterval) -> String {
    let intTime = Int(time)
    let retValue = String(format: "%d:%02d", Int(intTime / 60), intTime % 60)
    return retValue
  }

  func registerNotification() {
    let options: UNAuthorizationOptions = [.alert, .sound]
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: options) { (granted, error) in
      guard granted, error == nil else { return }

      let calendar = Calendar.current
      let components = calendar.dateComponents([.hour, .minute, .second], from: self.userDefinedTime!)

      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      let request = UNNotificationRequest(identifier: "timer",
                                          content: self.makeNotificationContent(),
                                          trigger: trigger)

      center.add(request) { _ in
        center.getPendingNotificationRequests(completionHandler: { _ in
          print("notification add completed")
        })
      }
    }
  }

  private func makeNotificationContent() -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.categoryIdentifier = "timer"
    content.body = "Time Out"

    return content
  }

  func completeTimer() {
    BTGlobalTimer.sharedInstance.stopTimer()
    timerLabel.text = "Time out"
    timerLabel.alpha = 1
    restartButton.alpha = 1
    preferenceButton.alpha = 1
  }
}

extension MainController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }

  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .fade
  }

  override var prefersStatusBarHidden: Bool {
    return statusBarHidden
  }
}