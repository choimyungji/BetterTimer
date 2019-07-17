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
//  var rect: CGRect?
  var boundsCenter: CGPoint?

  lazy private var arcLayer = CAShapeLayer().then {
    let path = UIBezierPath(arcCenter: boundsCenter!,
                            radius: bounds.size.width / 2,
                            startAngle: angleToDegree(angle: 0),
                            endAngle: angleToDegree(angle: 0),
                            clockwise: true)
    path.move(to: boundsCenter!)
    path.close()

    $0.path = path.cgPath
    $0.lineWidth = 1
    $0.strokeColor = UIColor.white.cgColor
    $0.fillColor = UIColor.white.cgColor
  }

  lazy private var centerOuterCircle = CAShapeLayer().then {
    let path = UIBezierPath(roundedRect: CGRect(x: bounds.origin.x,
                                                y: bounds.origin.y,
                                                width: bounds.size.width,
                                                height: bounds.size.width), cornerRadius: bounds.size.width / 2)

    $0.backgroundColor = UIColor.red.cgColor
    $0.path = path.cgPath
    $0.fillColor = UIColor.red.cgColor
  }

  lazy private var centerInnerCircle = CAShapeLayer().then {

    let path = UIBezierPath(roundedRect: CGRect(x: boundsCenter!.x - 80,
                                                y: boundsCenter!.x - 80,
                                                width: 160,
                                                height: 160), cornerRadius: 80)

    $0.backgroundColor = UIColor.white.cgColor
    $0.path = path.cgPath
    $0.fillColor = UIColor.white.cgColor
  }

  override func draw(_ rect: CGRect) {
    self.backgroundColor = .white
    boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    print(boundsCenter)

    layer.addSublayer(centerOuterCircle)
    layer.addSublayer(centerInnerCircle)
    layer.addSublayer(arcLayer)
  }

  func setCircularSector(degree: CGFloat) {
    var circleDegree = degree
    if circleDegree == 360.0 {
      circleDegree = 0
    }
    let path = CGMutablePath()

    path.move(to: boundsCenter!)
    path.addArc(center: boundsCenter!,
                radius: bounds.size.width / 2,
                startAngle: angleToDegree(angle: 0),
                endAngle: angleToDegree(angle: 360-circleDegree),
                clockwise: true)
    path.closeSubpath()

    let animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = arcLayer.path
    animation.toValue = path
    animation.duration = 0.3
    animation.timingFunction = CAMediaTimingFunction(name: .easeOut)

    arcLayer.add(animation, forKey: "animationKey")
    arcLayer.path = path
  }

  func angleToDegree(angle: CGFloat) -> CGFloat {
    let rad = CGFloat.pi * 2
    let degree = ((angle / 360) - 0.25) * rad

    print(degree)
    return degree
  }
}
