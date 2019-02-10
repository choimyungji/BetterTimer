//
//  MainArcView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 01/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class MainArcView: UIView {
  var context: CGContext?
  var rect: CGRect?
  var boundsCenter: CGPoint?

  lazy private var arcLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
//    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let path = UIBezierPath(arcCenter: boundsCenter!, radius: 120, startAngle: angleToDegree(angle: 0), endAngle: angleToDegree(angle: 0), clockwise: true)
    layer.backgroundColor = UIColor.white.cgColor
    layer.path = path.cgPath
    layer.lineWidth = 120
    layer.strokeColor = UIColor.red.cgColor

    return layer
  }()

  lazy private var centerCircle: CAShapeLayer = {
    let layer = CAShapeLayer()
    let path = UIBezierPath(roundedRect: CGRect(x: boundsCenter!.x - 40, y: boundsCenter!.x - 40, width: 80, height: 80), cornerRadius: 40)
    layer.backgroundColor = UIColor.white.cgColor
    layer.path = path.cgPath
    layer.fillColor = UIColor.white.cgColor

    return layer
  }()
  
  override func draw(_ rect: CGRect) {
    self.backgroundColor = .white
    boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)

    layer.addSublayer(arcLayer)
    layer.addSublayer(centerCircle)
  }

  func setCircularSector(degree: CGFloat) {
    let path = UIBezierPath(arcCenter: boundsCenter!, radius: 120, startAngle: angleToDegree(angle: 0), endAngle: angleToDegree(angle: degree), clockwise: true)
    arcLayer.path = path.cgPath
  }

  func angleToDegree(angle: CGFloat) -> CGFloat {
    let rad = CGFloat.pi * 2
    let a = ((angle / 360) - 0.25) * rad

    return a
  }
}
