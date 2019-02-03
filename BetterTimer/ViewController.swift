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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  var arcView: MainArcView?

  override func viewDidAppear(_ animated: Bool) {
    userDefinedTime = BTPreference.getInstance.userDefinedTime
    currentTime = 0
    BTGlobalTimer.sharedInstance.startTimer(target: self, selector: #selector(self.fTimerAction))

    let line = UIScreen.main.bounds.width - (defaultMargin * 2)
    let yPostion = (UIScreen.main.bounds.height - line) / 2

    arcView = MainArcView.init(frame: CGRect(x: defaultMargin, y: yPostion, width: line, height: line))
    view.addSubview(arcView!)
  }

  @objc func fTimerAction(sender: Any?) {
    currentTime += 1
    print(currentTime)
    let degree = CGFloat(currentTime) / CGFloat(userDefinedTime) * 360
    arcView?.setCircularSector(degree: degree)
  }
}

