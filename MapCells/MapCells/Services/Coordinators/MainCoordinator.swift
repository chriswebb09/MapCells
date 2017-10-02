//
//  MainCoordinator.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

final class MainCoordinator: AppCoordinator {
    
    weak var delegate: ControllerCoordinatorDelegate?
    var managedContext: NSManagedObjectContext
    var childCoordinators: [ControllerCoordinator] = []
    var window: UIWindow
    
    init(window: UIWindow, managedContext: NSManagedObjectContext) {
        self.window = window
        self.managedContext = managedContext
        transitionCoordinator(type: .start)
    }
    
    func add(_ childCoordinator: ControllerCoordinator) {
        childCoordinator.delegate = self
        childCoordinators.append(childCoordinator)
    }
    
    func remove(_ childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}

extension MainCoordinator: ControllerCoordinatorDelegate {
    
    // Switch between application flows
    
    func transitionCoordinator(type: CoordinatorType) {
        
        // Remove previous application flow
        
        childCoordinators.removeAll()
        
        switch type {
        case .start:
            let startCoordinator = StartControllerCoordinator(window: window, managedContext: self.managedContext)
            add(startCoordinator)
            startCoordinator.delegate = self
            startCoordinator.type = .start
            startCoordinator.start()
        case .list:
            let mainListCoordinator = MainListControllerCoordinator(window: window, managedContext: managedContext)
            mainListCoordinator.type = .list
            mainListCoordinator.start()
        }
    }
}
