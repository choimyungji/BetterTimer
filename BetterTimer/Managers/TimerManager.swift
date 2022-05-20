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
    static let shared = TimerManager()
    private init() { }

    var timer: Timer?
    var userDefinedTime: Date?

    @Published var count: TimeInterval = 0

    func start(completion: @escaping () -> Void) {
        timer?.invalidate()
        count = 0
        userDefinedTime = Date().addingTimeInterval(Preference.shared.userDefinedTimeInterval)

        let duration: TimeInterval = Preference.shared.userDefinedTimeInterval
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self,
                  let userDefinedTime = self.userDefinedTime
            else { return }

            self.count = min(duration - Date().distance(to: userDefinedTime), duration)

            completion()
            if self.count >= duration {
                self.timer?.invalidate()
            }
        })
    }

    func refresh() {
        count = 0
    }
}
