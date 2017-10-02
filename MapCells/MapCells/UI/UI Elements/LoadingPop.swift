//
//  LoadingPop.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class LoadingPopover: UIView {
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black
        containerView.layer.opacity = 0.4
        return containerView
    }()

    func configureContainer() {
        containerView.layer.opacity = 0
    }
    
    var animating: Bool {
        guard let ball = self.popView.ball else { return false }
        return ball.isAnimating
    }
    
    var popView: LoadingView = {
        let popView = LoadingView()
        popView.layer.cornerRadius = 2
        popView.isUserInteractionEnabled = true
        return popView
    }()
    
    func showPopView(viewController: UIViewController) {
        containerView.isHidden = false
        containerView.frame = UIScreen.main.bounds
        containerView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        viewController.view.addSubview(containerView)
        popView.frame = CGRect(x: UIScreen.main.bounds.midX,
                               y: UIScreen.main.bounds.midY,
                               width: UIScreen.main.bounds.width / 3,
                               height: UIScreen.main.bounds.height / 5.5)
        popView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY / 1.2)
        DispatchQueue.main.async {
            self.popView.layer.cornerRadius = 4
        }
        popView.clipsToBounds = true
        viewController.view.addSubview(popView)
        viewController.view.bringSubview(toFront: popView)
        containerView.backgroundColor = .black
        containerView.frame = UIScreen.main.bounds
    }
    
    func hidePopView(viewController: UIViewController) {
        viewController.view.sendSubview(toBack: containerView)
        containerView.isHidden = true
        viewController.view.sendSubview(toBack: popView)
        popView.stopAnimating()
        popView.removeFromSuperview()
    }
    
    func setupPop() {
        popView.configureView()
        popView.backgroundColor = .white
        popView.alpha = 0.8
    }
    
    func configureLoadingOpacity(alpha: CGFloat) {
        containerView.alpha = alpha
    }
    
    func show(controller: UIViewController) {
        setupPop()
        showPopView(viewController: controller)
        popView.isHidden = false
    }
    
    func hideLoadingView(controller: UIViewController) {
        popView.removeFromSuperview()
        removeFromSuperview()
        popView.ball?.removeFromSuperview()
        hidePopView(viewController: controller)
        controller.view.sendSubview(toBack: self)
    }
}
