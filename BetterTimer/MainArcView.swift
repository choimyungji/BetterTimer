//
//  MainArcView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 01/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit
import Then

class MainArcView: UIView {
  var context: CGContext?
  var boundsCenter: CGPoint?

  lazy private var arcLayer = CAShapeLayer().then {
    let path = UIBezierPath(arcCenter: boundsCenter!,
                            radius: bounds.size.width / 2 - 80,
                            startAngle: angleToDegree(angle: 0),
                            endAngle: angleToDegree(angle: 360),
                            clockwise: true)
    path.move(to: boundsCenter!)
    path.close()

    $0.path = path.cgPath
    $0.lineWidth = 80
    $0.strokeColor = UIColor.red.cgColor
    $0.fillColor = UIColor.white.cgColor
    $0.strokeEnd = 0
  }

  override func draw(_ rect: CGRect) {
    self.backgroundColor = .white
    boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    layer.addSublayer(arcLayer)
  }

  func setCircularSector(degree: CGFloat) {
    print(arcLayer.strokeEnd)
    var circleDegree = degree
    if circleDegree == 360.0 {
      circleDegree = 0
    }

    arcLayer.strokeEnd = 1.0 / 360 * degree
  }

  private func angleToDegree(angle: CGFloat) -> CGFloat {
    let rad = CGFloat.pi * 2
    let degree = ((angle / 360) - 0.25) * rad
    return degree
  }
}
