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
         timerManager: TimerManager = TimerManager.shared) {

        self.notificationManager = notificationManager
        self.timerManager = timerManager
    }

    private let notificationManager: NotificationManager
    @ObservedObject private var timerManager: TimerManager

    @Published var degree: Double = 0
    @Published var seconds: String = "00:00"
    @Published var totalSeconds: String = "00:00"

    func start() {
        totalSeconds = convertTimeInteger(with: Preference.shared.userDefinedTimeInterval)
        timerManager.start { [weak self] in
            guard let self = self else { return }
            self.degree = self.timerManager.count / Preference.shared.userDefinedTimeInterval * 360
            self.seconds = self.convertTimeInteger(with: self.timerManager.count)
        }

        let date = Date().addingTimeInterval(Preference.shared.userDefinedTimeInterval)
        notificationManager.registerNotification(date: date)
    }

    func refresh() {
        timerManager.refresh()
    }

    private func convertTimeInteger(with time: TimeInterval) -> String {
        let intTime = Int(time)
        let retValue = String(format: "%d:%02d", Int(intTime / 60), intTime % 60)
        return retValue
    }
}
