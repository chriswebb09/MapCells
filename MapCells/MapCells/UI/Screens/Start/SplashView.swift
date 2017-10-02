//
//  SplashView.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias Completion = () -> Void

final class SplashView: UIView {
    
    weak var delegate: SplashViewDelegate?
    var animationDuration: Double = 0.8
    // MARK: - UI Properties
    var drone: UIImageView = {
        let image = #imageLiteral(resourceName: "drone-img")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    // MARK: - Configuration methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(drone)
        frame = UIScreen.main.bounds
        setup(logoImageView: drone)
        backgroundColor = .white
    }
    
    private func setup(logoImageView: UIImageView) {
        addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Animation
    func zoomAnimation(_ handler: Completion? = nil) {
        let duration: TimeInterval = animationDuration
        drone.isHidden = false
        alpha = 0.7
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.drone.transform = CGAffineTransform(scaleX: 8, y: 18)
            strongSelf.alpha = 0
            }, completion: { finished in
                DispatchQueue.main.async {
                    self.delegate?.animation(true)
                }
                handler?()
        })
    }
}
