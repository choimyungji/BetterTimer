//
//  AppCoordinator.swift
//  BetterTimer
//
//  Created by Myungji Choi on 30/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

  init(_ window: UIWindow) {
    self.window = window
  }

  private let window: UIWindow
  private let navigationController = UINavigationController()
  private var mainViewController: MainController?

  var rootViewController: UIViewController {
    return navigationController
  }

  var childCoordinators: [Coordinator] = []

  func start() {
    let controller = MainController(MainViewModel(NotificationManager(),
                                                  timerManager: TimerManager(),
                                                  navigationDelegate: self))
    navigationController.setViewControllers([controller], animated: false)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    mainViewController = controller
  }
}

extension AppCoordinator: NavigationDelegate {
  func preferenceButtonSelected() {
    let preferenceViewController = PreferenceController()

    mainViewController?.navigationController?.pushViewController(preferenceViewController, animated: true)
    mainViewController?.navigationController?.navigationBar.isHidden = false
  }
}
