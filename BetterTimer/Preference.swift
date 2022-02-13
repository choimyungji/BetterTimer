//
//  BTPreference.swift
//  BetterTimer
//
//  Created by Myungji Choi on 02/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class Preference: NSObject {
  private let userDefinedTimeIntervalKey = "userDefinedTimeInterval"

  static let shared = Preference()

  private override init() {
    super.init()
  }

  var userDefinedTimeInterval: TimeInterval {
    get {
      return UserDefaults().object(forKey: userDefinedTimeIntervalKey) as? TimeInterval ?? 1.0 * 10
    }
    set (newVal) {
      UserDefaults().set(newVal, forKey: userDefinedTimeIntervalKey)
    }
  }
}
