//
//  TableViewable.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/2/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol TableViewable: class {
    var tableView: UITableView { get set }
    var dataSource: MainListDataSource! { get set }
    var managedContext: NSManagedObjectContext! { get set }
    var sections: [String] { get set }
    var locations: [FilmLocation] { get set }
    var selectedIndex: IndexPath! { get set }
}

extension TableViewable {
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.height / 4
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        tableView.register(FilmCell.self, forCellReuseIdentifier: "FilmCell")
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.backgroundColor = .white
    }
    
    func getDataFromNetwork() {
        let store = MainListDataStore()
        store.getDataFromNetwork(managedContext: managedContext) { locations in
            self.locations = locations
            self.sections = locations.map { $0.title! }
            let set = Set(self.sections)
            self.sections = Array(set)
            self.dataSource.locations.append(contentsOf: locations)
        }
    }
    
    func getCoordinate(for state: DataState, cell: FilmCell, completion: @escaping (Error?) -> Void) {
        var locationString = ""
        let converter = CoordinateConverter()
        switch state {
        case .network:
            let location = locations[selectedIndex.row]
            locationString = converter.getAddress(from: location.locationName)
            converter.getCoordinates(searchString: locationString) { coordinate, error in
                if let error = error {
                    completion(error)
                } else {
                    location.coordinate = coordinate!
                    cell.updateMap(film: location)
                }
            }
        case .saved:
            let movie = dataSource.fetchedResultsController.object(at: selectedIndex)
            let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            let film = FilmLocation(locationName: "", title: "", date: "", coordinate: coordinate, uid: "")
            if let title = movie.title {
                film.title = title
            }
            if let name = movie.locationName {
                film.locationName = name
            }
            if let uid = movie.uid {
                film.uid = uid
            }
            if movie.latitude != 0 && movie.longitude != 0 {
                let coordinate = CLLocationCoordinate2D(latitude: movie.latitude, longitude: movie.longitude)
                film.coordinate = coordinate
                cell.updateMap(film: film)
            } else {
                locationString = converter.getAddress(from: film.locationName)
                converter.getCoordinates(searchString: locationString) { coordinate, error in
                    if let error = error {
                        completion(error)
                    } else {
                        movie.latitude = (coordinate?.latitude)!
                        movie.longitude = (coordinate?.longitude)!
                        film.coordinate = coordinate!
                        cell.updateMap(film: film)
                        do {
                            try self.managedContext.save()
                        } catch let error {
                            completion(error)
                        }
                    }
                }
            }
        }
    }
}
