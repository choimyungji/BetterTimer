//
//  ViewController.swift
//  BetterTimer
//
//  Created by Myungji Choi on 31/01/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewDidAppear(_ animated: Bool) {
    BTGlobalTimer.sharedInstance.startTimer()

    let arcView = MainArcView.init(frame: CGRect(x: 10, y: 100, width: 100, height: 100))
    view.addSubview(arcView)
  }
}

