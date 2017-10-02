//
//  ControllerCoordinatorDelegate.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

protocol ControllerCoordinatorDelegate: CoordinatorDelegate {
    func transitionCoordinator(type: CoordinatorType)
}
