//
//  Headers.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

struct Headers {
    static func getHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["X-App-Token"] = "L3ng0vJbF0wSz9Jz45YfRMRCF"
        headers["Accept"] = "application/json"
        headers["Host"] = "data.sfgov.org"
        return headers
    }
}
