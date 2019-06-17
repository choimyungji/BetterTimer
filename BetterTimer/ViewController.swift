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
  var userDefinedTime: Int = 0
  var currentTime: Int = 0
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

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    UIView.animate(withDuration: 1) {
      self.timerLabel.alpha = self.isShownViewComponent ? 1 : 0
      self.restartButton.alpha = self.isShownViewComponent ? 1 : 0
    }
    isShownViewComponent.toggle()
  }

  @objc func refresh() {
    currentTime = 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPosition = UIScreen.main.bounds.height - 220
    timerLabel.frame = CGRect(x: defaultMargin, y: yPosition, width: line, height: 30)
    view.addSubview(timerLabel)
    timerLabel.text = convertTimeInteger(with: BTPreference.getInstance.userDefinedTime)

    restartButton.frame = CGRect(x: defaultMargin, y: yPosition + 40, width: line, height: 30)
    view.addSubview(restartButton)
  }

  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 4) {
      self.timerLabel.alpha = 0
      self.restartButton.alpha = 0
    }
    userDefinedTime = BTPreference.getInstance.userDefinedTime
    currentTime = 0
    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))
    registerNotification()

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPostion = (UIScreen.main.bounds.height - line) / 2

    arcView = MainArcView(frame: CGRect(x: defaultMargin, y: yPostion, width: line, height: line))
    view.addSubview(arcView!)
    statusBarHidden = true
  }

  @objc func fTimerAction(sender: Any?) {
    currentTime += 1
    if currentTime > BTPreference.getInstance.userDefinedTime {
      completeTimer()
      return
    }
    let degree = CGFloat(currentTime) / CGFloat(userDefinedTime) * 360
    arcView?.setCircularSector(degree: degree)
    timerLabel.text = convertTimeInteger(with: BTPreference.getInstance.userDefinedTime - currentTime)
  }

  func convertTimeInteger(with: Int) -> String {
    let retValue = String(format: "%d:%02d", Int(with / 60), with % 60)
    return retValue
  }

  func registerNotification() {
    let options: UNAuthorizationOptions = [.alert, .sound]
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: options) { (granted, error) in
      guard granted else { return }

      let calendar = Calendar.current
      let date = calendar.date(byAdding: .second,
                                     value: BTPreference.getInstance.userDefinedTime,
                                     to: Date())

      let components = calendar.dateComponents([.hour, .minute, .second], from: date!)

      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      let request = UNNotificationRequest(identifier: "timer",
                                          content: self.makeNotificationContent(),
                                          trigger: trigger)

      center.add(request) { _ in
        center.getPendingNotificationRequests(completionHandler: { _ in
          print("completed")
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
