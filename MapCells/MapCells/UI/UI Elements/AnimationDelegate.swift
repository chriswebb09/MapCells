//
//  AnimationDelegate.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol AnimationDelegate: class {
    func drawAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}
