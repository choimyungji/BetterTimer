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
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    timerLabel.frame = CGRect(x: 20, y: 50, width: 200, height: 50)
    view.addSubview(timerLabel)
    timerLabel.text = String(BTPreference.getInstance.userDefinedTime)
  }

  override func viewDidAppear(_ animated: Bool) {
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
    timerLabel.text = String(BTPreference.getInstance.userDefinedTime - currentTime)
  }
}

