//
//  TimerManager.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation

class TimerManager {
    var timer: Timer?
    var userDefinedTime =  Date().addingTimeInterval(BTPreference.getInstance.userDefinedTimeInterval)
    
    init() {
        let duration: TimeInterval = BTPreference.getInstance.userDefinedTimeInterval
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { _ in
            print("FIRE!!!")
        })
    }
}
