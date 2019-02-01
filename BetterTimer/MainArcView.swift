//
//  MainArcView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 01/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class MainArcView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code . r
    }
    */
  override func draw(_ rect: CGRect) {
    self.backgroundColor = .white
    if let context = UIGraphicsGetCurrentContext() {
      context.addRect(rect)
      context.setFillColor(UIColor.white.cgColor)
      context.fillPath()

      context.addEllipse(in: rect)
      context.setFillColor(UIColor.red.cgColor)
      context.fillPath()
    }
  }
}
