//
//  Coordinator.swift
//  BetterTimer
//
//  Created by Myungji Choi on 30/08/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

protocol Coordinator: class {
  var rootViewController: UIViewController { get }
  var childCoordinators: [Coordinator] { get set }
  func start()
}

extension Coordinator {
  func addChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
  }
}
