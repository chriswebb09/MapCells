//
//  ApplicationCoordinator.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol AppCoordinator: Coordinator {
    weak var delegate: ControllerCoordinatorDelegate? { get set }
    var childCoordinators: [ControllerCoordinator] { get set }
}
