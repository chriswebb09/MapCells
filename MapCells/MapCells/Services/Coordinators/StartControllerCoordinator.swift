//
//  StartControllerCoordinator.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

class StartControllerCoordinator: ControllerCoordinator {
    
    internal var window: UIWindow
    
    var managedContext: NSManagedObjectContext!
    
    internal var rootController: RootController!
    
    weak var delegate: ControllerCoordinatorDelegate?
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            let startViewController = StartViewController()
            startViewController.delegate = self
            rootController = startViewController
        }
    }
    
    init(window: UIWindow, managedContext: NSManagedObjectContext) {
        self.window = window
        self.managedContext = managedContext
        type = .list
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension StartControllerCoordinator: SplashViewControllerDelegate {
    
    func splashAnimation(finished: Bool) {
        delegate?.transitionCoordinator(type: .list)
    }
}
