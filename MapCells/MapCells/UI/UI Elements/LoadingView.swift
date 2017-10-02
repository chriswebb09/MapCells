//
//  LoadingView.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    var ball: BallIndicatorView?
    var containerView: UIView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
    }
    
    func configureView() {
        layoutSubviews()
        addSubview(containerView)
        let x = frame.origin.x
        let y = frame.origin.y
        let width = frame.width / 3
        let height = frame.height / 3
        containerView.frame = CGRect(x: x, y: y, width: width, height: height)
        setupConstraints()
        containerView.backgroundColor = .white
        containerView.alpha = 0.8
    }
    
    func setContainerViewAlpha(alpha: CGFloat) {
        containerView.alpha = alpha
    }
    
    func startAnimating() {
        ball?.startAnimating()
    }
    
    func stopAnimating() {
        ball?.stopAnimating()
    }
    
    private func setupConstraints() {
        let xy: CGFloat = -35
        let width = UIScreen.main.bounds.width / 2
        let height = UIScreen.main.bounds.width / 2.1
        let color = UIColor(red:0.00, green:0.70, blue:1.00, alpha:1.0)
        let size = CGSize(width: 70, height: 20)
        let ballAnimation = BallAnimation(size: size)
        let newFrame = CGRect(x: xy,
                              y: xy,
                              width: width,
                              height: height)
        ball = BallIndicatorView(frame: newFrame,
                                 color: color,
                                 padding: 80,
                                 animationType: ballAnimation)
        guard let ball = ball else { return }
        addSubview(ball)
        bringSubview(toFront: ball)
        ball.startAnimating()
    }
}
