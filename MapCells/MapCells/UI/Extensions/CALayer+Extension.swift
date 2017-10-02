//
//  CALayer+Extension.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension CALayer {
    static func drawCircleLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        let center = CGPoint(x: size.width, y: size.height)
        path.addArc(withCenter: center,
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height / 2)
        return layer
    }
    static func setupShadow(view: UIView) {
        let shadowOffset = CGSize(width:-0.4, height: 0.08)
        let shadowRadius: CGFloat = 0.6
        let shadowOpacity: Float = 0.18
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = shadowOpacity
    }
}
