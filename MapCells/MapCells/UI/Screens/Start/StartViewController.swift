//
//  StartViewController.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController, Controller {
    
    var type: ControllerType = .start
    
    weak var delegate: SplashViewControllerDelegate?
    
    private let splashView: SplashView!
    
    init(splashView: SplashView = SplashView()) {
        self.splashView = splashView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        splashView.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        splashView.frame = view.frame
        view.addSubview(splashView)
        splashView.zoomAnimation {
            print("animation")
        }
    }
}

// MARK: - SplashViewDelegate

extension StartViewController: SplashViewDelegate {
    
    func animation(_ isComplete: Bool) {
        animate()
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            if let strongSelf = self {
                strongSelf.delegate?.splashAnimation(finished: true)
            }
        }
    }
}

