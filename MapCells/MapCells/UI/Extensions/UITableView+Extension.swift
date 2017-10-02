//
//  UITableView+Extension.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ :T.Type) where T: Reusable {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell")
        }
        return cell
    }
    
    func setupTableView() {
        register(FilmCell.self)
        
    }
}
