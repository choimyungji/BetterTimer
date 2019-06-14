//
//  BTPreference.swift
//  BetterTimer
//
//  Created by Myungji Choi on 02/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class BTPreference: NSObject {
  let userDefinedTimeKey = "userDefinedTime"

  static let getInstance = BTPreference()

  private override init() {
    super.init()
  }

  var userDefinedTime: Int {
    set (newVal) {
      UserDefaults().set(newVal, forKey: userDefinedTimeKey)
    }
    get {
      return UserDefaults().object(forKey: userDefinedTimeKey) as? Int ?? 25 * 60
    }
  }
}
