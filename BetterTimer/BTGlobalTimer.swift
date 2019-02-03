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

  func startTimer(target: Any, selector: Selector) {
    if internalTimer == nil {
      internalTimer?.invalidate()
    }
    self.internalTimer = Timer.scheduledTimer(timeInterval: 1, target: target, selector: selector, userInfo: nil, repeats: true)
//    Timer.init(fireAt: <#T##Date#>, interval: <#T##TimeInterval#>, target: <#T##Any#>, selector: <#T##Selector#>, userInfo: <#T##Any?#>, repeats: <#T##Bool#>)
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

