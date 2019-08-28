//
//  NotificationManager.swift
//  BetterTimer
//
//  Created by Myungji Choi on 28/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
  var userDefinedTime: Date?
  
  func registerNotification() {
    let options: UNAuthorizationOptions = [.alert, .sound]
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: options) { (granted, error) in
      guard granted, error == nil else { return }

      let calendar = Calendar.current
      let components = calendar.dateComponents([.hour, .minute, .second], from: self.userDefinedTime!)

      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
      let request = UNNotificationRequest(identifier: "timer",
                                          content: self.makeNotificationContent(),
                                          trigger: trigger)

      center.add(request) { _ in
        center.getPendingNotificationRequests(completionHandler: { _ in
          print("notification add completed")
        })
      }
    }
  }

  private func makeNotificationContent() -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.categoryIdentifier = "timer"
    content.body = "Time Out"

    return content
  }

}
