//
//  BTPreference.swift
//  BetterTimer
//
//  Created by Myungji Choi on 02/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class BTPreference: NSObject {
  private let userDefinedTimeIntervalKey = "userDefinedTimeInterval"

  static let getInstance = BTPreference()

  private override init() {
    super.init()
  }

  var userDefinedTimeInterval: TimeInterval {
    set (newVal) {
      UserDefaults().set(newVal, forKey: userDefinedTimeIntervalKey)
    }
    get {
      return UserDefaults().object(forKey: userDefinedTimeIntervalKey) as? TimeInterval ?? 25.0 * 60
    }
  }
}
