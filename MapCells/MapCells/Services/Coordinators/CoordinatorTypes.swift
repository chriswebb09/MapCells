//
//  CoordinatorTypes.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

typealias RootController = UIViewController & Controller

enum CoordinatorType {
    case start, list
}

enum  ControllerType {
    case start, list, none
}
