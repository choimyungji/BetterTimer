//
//  MainViewModel.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class MainViewModel: ObservableObject {

    init(notificationManager: NotificationManager = NotificationManager(),
         timerManager: TimerManager = TimerManager()) {

        self.notificationManager = notificationManager
        self.timerManager = timerManager

        let date = Date().addingTimeInterval(Preference.shared.userDefinedTimeInterval)
        notificationManager.registerNotification(date: date)
    }

    private let notificationManager: NotificationManager
    @ObservedObject var timerManager: TimerManager

    @Published var seconds: Double = 0
    func start() {
        timerManager.start {
            self.seconds = self.timerManager.count
        }
    }

    func refresh() {
        timerManager.userDefinedTime = Date().addingTimeInterval(Preference.shared.userDefinedTimeInterval)
    }

    private func convertTimeInteger(with time: TimeInterval) -> String {
        let intTime = Int(time)
        let retValue = String(format: "%d:%02d", Int(intTime / 60), intTime % 60)
        return retValue
    }
}
