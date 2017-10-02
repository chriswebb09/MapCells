//
//  Reusable.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

protocol Reusable { }

extension Reusable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
