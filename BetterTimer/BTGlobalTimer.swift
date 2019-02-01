//
//  BTGlobalTimer.swift
//  BetterTimer
//
//  Created by Myungji Choi on 01/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit
//import Alamofire

class BTGlobalTimer: NSObject {
  static let sharedInstance: BTGlobalTimer = {
    let timer = BTGlobalTimer()
    return timer
  }()
  var internalTimer: Timer?

  private override init() {
    super.init()
  }

  func startTimer() {
    if internalTimer == nil {
      internalTimer?.invalidate()
    }
    self.internalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
  }

  func stopTimer() {
    guard self.internalTimer != nil else {
      return
    }
    self.internalTimer?.invalidate()
  }

  @objc func fireTimerAction(sender: Any?) {
    print("timer")
//    getMyNewsList()
  }
}

