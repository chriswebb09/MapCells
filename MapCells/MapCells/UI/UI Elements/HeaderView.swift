//
//  HeaderView.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, Reusable {
    func setText(string: String, for sort: String) {
        textLabel?.text = "\(sort)\(string)"
    }
    
    func setup() {
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor(white: 0.5, alpha: 1)
        self.backgroundView = backgroundView
        backgroundColor = .black
        textLabel?.textColor = .white
    }
}
