//
//  MainListControllerCoordinator.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

class MainListControllerCoordinator: ControllerCoordinator {
    
    internal var window: UIWindow
    var managedContext: NSManagedObjectContext!
    internal var rootController: RootController!
    weak var delegate: ControllerCoordinatorDelegate?
    
    private var navigationController: UINavigationController {
        return UINavigationController(rootViewController: rootController)
    }
    
    var type: ControllerType {
        didSet {
            let mainListViewController = MainListViewController()
            mainListViewController.managedContext = managedContext
            rootController = mainListViewController
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
