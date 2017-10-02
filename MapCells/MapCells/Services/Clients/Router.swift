//
//  Router.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

enum URLRouter {
    
    case base
    
    var url: String {
        switch self {
        case .base:
            return "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
        }
    }
}
