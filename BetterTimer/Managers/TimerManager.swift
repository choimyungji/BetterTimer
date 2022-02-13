//
//  TimerManager.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation
import Combine

class TimerManager: ObservableObject {
    var timer: Timer?
    var userDefinedTime =  Date().addingTimeInterval(Preference.shared.userDefinedTimeInterval)

    @Published var count: TimeInterval = 0

    func start(completion: @escaping () -> Void) {
        let duration: TimeInterval = Preference.shared.userDefinedTimeInterval
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            guard self.count < duration else {
                self.timer?.invalidate()
                return
            }
            self.count += 1
            completion()
        })
    }
}
