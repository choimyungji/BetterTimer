//
//  ViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 31/01/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var userDefinedTime: Int = 0
  var currentTime: Int = 0
  let defaultMargin: CGFloat = 24

  var arcView: MainArcView?
  private lazy var timerLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    label.font = UIFont.systemFont(ofSize: 40, weight: .ultraLight)
    label.textAlignment = .center
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPosition = UIScreen.main.bounds.height - 220
    timerLabel.frame = CGRect(x: defaultMargin, y: yPosition, width: line, height: 30)
    view.addSubview(timerLabel)
    timerLabel.text = convertTimeInteger(with: BTPreference.getInstance.userDefinedTime)
  }

  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 4) {
      self.timerLabel.alpha = 0
    }
    userDefinedTime = BTPreference.getInstance.userDefinedTime
    currentTime = 0
    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPostion = (UIScreen.main.bounds.height - line) / 2

    arcView = MainArcView(frame: CGRect(x: defaultMargin, y: yPostion, width: line, height: line))
    view.addSubview(arcView!)
  }

  @objc func fTimerAction(sender: Any?) {
    currentTime += 1
    if currentTime > BTPreference.getInstance.userDefinedTime {
      BTGlobalTimer.sharedInstance.stopTimer()
    }
    let degree = CGFloat(currentTime) / CGFloat(userDefinedTime) * 360
    arcView?.setCircularSector(degree: degree)
    timerLabel.text = convertTimeInteger(with: BTPreference.getInstance.userDefinedTime - currentTime)
  }

  func convertTimeInteger(with: Int) -> String {
    let retValue = String(format: "%d:%02d", Int(with / 60), with % 60)
    return retValue
  }
}
