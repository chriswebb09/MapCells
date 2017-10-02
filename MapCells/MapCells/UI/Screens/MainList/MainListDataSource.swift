//
//  MainListDataSource.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData

class MainListDataSource: NSObject, UITableViewDataSource {
    
    var animating: Bool = false {
        didSet {
            if animating == false {
                delegate?.stopAnimating()
            }
        }
    }
    var state: DataState = .network
    var tableView: UITableView?
    weak var delegate: MainListDataSourceDelegate?
    var locations: [FilmLocation] = [] {
        didSet {
            sections = locations.map { $0.title! }
            let set = Set(self.sections)
            sections = Array(set)
            for section in sections {
                DispatchQueue.main.async {
                    let sectionLocal = self.locations.filter { $0.title == section }
                    self.sectionLocations[section] = sectionLocal
                }
            }
            let secDates = locations.map { $0.date }
            for date in secDates {
                let sectionDate = locations.filter { $0.date == date }
                sectionDates[date] = sectionDate
            }
        }
    }
    
    var dateSortDescriptor = [NSSortDescriptor(key: "date", ascending: true)]
    var titleSortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]
    
    var sectionLocations: [String: [FilmLocation]] = [:]

    var sectionDates: [String: [FilmLocation]] = [:]
    var sections: [String] = []
    let fetch: NSFetchRequest<Movie> = Movie.fetchRequest()
    let fetchRequest:NSFetchRequest<Movie> = Movie.fetchRequest()
    var fetchedResultsController:NSFetchedResultsController<Movie>!
    
    init(manageContext: NSManagedObjectContext) {
        fetchRequest.sortDescriptors =  [NSSortDescriptor(key: "title", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageContext, sectionNameKeyPath: "title", cacheName: nil)

        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch state {
            
        case .network:
            return sections.count
        case .saved:
            if let sections = fetchedResultsController.sections {
                return sections.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .network:
            let locationsSection =  locations.filter { $0.title! == sections[section] }
            return locationsSection.count
        case .saved:
            if let sections = fetchedResultsController.sections {
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilmCell
        switch state {
        case .network:
            let sectionName = sections[indexPath.section]
            DispatchQueue.main.async {
                let items = self.sectionLocations[sectionName]!
                let new = items[indexPath.row]
                cell.setup(with: new.title!, locationName: new.locationName, and: new.date)
            }
        case .saved:
            let movie = fetchedResultsController.object(at: indexPath)
            if let title = movie.title, let name = movie.locationName, let date = movie.date {
                let stringDate = String(describing: date)
                let year = stringDate.prefix(4)
                cell.setup(with: title, locationName: name, and: String(year))
            }
        }
        cell.backgroundColor = .white
        return cell
    }
}
