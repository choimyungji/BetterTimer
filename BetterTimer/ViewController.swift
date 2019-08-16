//
//  ViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 31/01/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
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
  private lazy var timerLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    label.font = UIFont.systemFont(ofSize: 40, weight: .ultraLight)
    label.textAlignment = .center
    return label
  }()

  private lazy var restartButton: UIButton = {
    let button = UIButton()
    button.setTitle("Refresh", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    return button
  }()

  private lazy var preferenceButton: UIButton = {
    let button = UIButton()
    button.setTitle("Edit", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.addTarget(self, action: #selector(edit), for: .touchUpInside)
    return button
  }()

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 1) {
      self.timerLabel.alpha = self.isShownViewComponent ? 1 : 0
      self.restartButton.alpha = self.isShownViewComponent ? 1 : 0
      self.preferenceButton.alpha = self.isShownViewComponent ? 1 : 0
      self.statusBarHidden = !self.isShownViewComponent
    }
    isShownViewComponent.toggle()
  }

  @objc func refresh() {
    userDefinedTime = Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))
  }

  @objc func edit() {
    let preferenceViewController = PreferenceViewController()
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
//      return
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
    restartButton.isHidden = false
  }
}

extension ViewController {
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
