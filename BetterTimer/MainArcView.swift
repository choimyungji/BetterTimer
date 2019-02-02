//
//  MainArcView.swift
//  BetterTimer
//
//  Created by Myungji Choi on 01/02/2019.
//  Copyright © 2019 Myungji Choi. All rights reserved.
//

import UIKit

class MainArcView: UIView {
  var rect: CGRect?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code . r
    }
    */

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.rect = frame
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    self.backgroundColor = .white
    if let context = UIGraphicsGetCurrentContext() {
      context.addRect(rect)
      context.setFillColor(UIColor.white.cgColor)
      context.fillPath()

      context.addEllipse(in: rect)
      context.setFillColor(UIColor.red.cgColor)
      context.fillPath()

      let center = CGPoint(x: rect.midX, y: rect.midY)
      
      let path = UIBezierPath(arcCenter: center, radius: 40, startAngle: angleToDegree(angle: 0), endAngle: angleToDegree(angle: 90), clockwise: true)
      path.move(to: center)
      path.fill()

      path.close()
      context.addPath(path.cgPath)

    }
  }

  func setCircularSector(degree: CGFloat) {
    guard let rect = self.rect else { return }
    let center = CGPoint(x: rect.midX, y: rect.midY)

    if let context = UIGraphicsGetCurrentContext() {
      context.addArc(center: center, radius: 40, startAngle: angleToDegree(angle: 0),
                     endAngle: angleToDegree(angle: degree), clockwise: true)
      context.setFillColor(UIColor.black.cgColor)
      context.fillPath()
    }
  }

  func angleToDegree(angle: CGFloat) -> CGFloat {
    let rad = CGFloat.pi * 2
    let a = ((angle / 360) + 0.75) * rad
    print(a)

    return a
  }
}
