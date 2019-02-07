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
  lazy private var arcLayer: CAShapeLayer = {
    let layer = CAShapeLayer()

    let path = UIBezierPath(arcCenter: center, radius: 60, startAngle: angleToDegree(angle: 0), endAngle: angleToDegree(angle: 90), clockwise: true)

    layer.path = path.cgPath
    layer.lineWidth = 60
    layer.strokeColor = UIColor.blue.cgColor

    return layer
  }()

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
      self.context = context
      context.addRect(rect)
      context.setFillColor(UIColor.white.cgColor)
      context.fillPath()

      context.addEllipse(in: rect)
      context.setFillColor(UIColor.red.cgColor)
      context.fillPath()
    }

    layer.addSublayer(arcLayer)
  }

  func imageByDrawingCircle(on image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: image.size.width, height: image.size.height), false, 0.0)

    // draw original image into the context
    image.draw(at: CGPoint.zero)

    // get the context for CoreGraphics
    let ctx = UIGraphicsGetCurrentContext()!

    // set stroking color and draw circle
    ctx.setStrokeColor(UIColor.red.cgColor)

    // make circle rect 5 px from border
    var circleRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    circleRect = circleRect.insetBy(dx: 5, dy: 5)

    // draw circle
    ctx.strokeEllipse(in: circleRect)

    // make image out of bitmap context
    let retImage = UIGraphicsGetImageFromCurrentImageContext()!

    // free the context
    UIGraphicsEndImageContext()

    return retImage;
  }

  func setCircularSector(degree: CGFloat) {
    guard let rect = self.rect else { return }
//    guard let context = self.context else { return }

//    UIGraphicsBeginImageContext(rect.size)
//    if let context = UIGraphicsGetCurrentContext() {
//    let center = CGPoint(x: rect.midX, y: rect.midY)
//
//      context.move(to: center)
//      context.addArc(center: center, radius: 40, startAngle: angleToDegree(angle: degree),
//                     endAngle: angleToDegree(angle: 0), clockwise: true)
//      context.move(to: center)
//      context.closePath()
//
//      context.setFillColor(UIColor.black.cgColor)
//      context.fillPath()
//    }
//    UIGraphicsEndImageContext()
    let path = UIBezierPath(arcCenter: center, radius: 60, startAngle: angleToDegree(angle: 0), endAngle: angleToDegree(angle: degree), clockwise: true)
    arcLayer.path = path.cgPath

  }

  func angleToDegree(angle: CGFloat) -> CGFloat {
    let rad = CGFloat.pi * 2
    let a = ((angle / 360) - 0.25) * rad
    print(a)

    return a
  }
}
