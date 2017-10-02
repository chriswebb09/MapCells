//
//  ViewController.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/29/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainListViewController: UIViewController {
    var filters: [String] = ["Title", "Year"]
    var loadingPop = LoadingPopover()
    var dataSource: MainListDataSource!
    var type: ControllerType = .list
    let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
    var managedContext: NSManagedObjectContext!
    let segmentedControl = UISegmentedControl(frame: CGRect.zero)
    var selectedIndex: IndexPath!
    var fetchedResultsController: NSFetchedResultsController<Movie>!
    var tableView = UITableView(frame: UIScreen.main.bounds)
    
    var selectedSection: String! {
        didSet {
            guard let selectedSection = selectedSection else { return }
            self.title = "By: \(selectedSection)"
        }
    }
    
    var locations: [FilmLocation] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var sections: [String] = [] {
        didSet {
            dataSource.animating = false
            segmentedControl.selectedSegmentIndex = 0
            segmentedControlValueChanged(sender: segmentedControl)
        }
    }
    
    var state: DataState = .network {
        didSet {
            dataSource.state = state
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Loading..."
        configure()
    }
}

extension MainListViewController: Controller {
    
    func configure() {
        dataSource = MainListDataSource(manageContext: managedContext)
        dataSource.delegate = self
        guard let navController = navigationController else { return }
        let navFrame = navController.navigationBar.frame
        view.addSubview(segmentedControl)
        segmentedControl.frame = CGRect(x: navFrame.minX, y: 0, width: navFrame.width + 5, height: 41)
        view.frame = UIScreen.main.bounds
        tableView.frame = CGRect(x: segmentedControl.frame.minX,
                                 y: segmentedControl.frame.maxY,
                                 width: navFrame.width,
                                 height: UIScreen.main.bounds.height - 40)
        view.addSubview(tableView)
        platformSetup()
        do {
            try dataSource.fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error {
            presentMessage(title: "Error", message: error.localizedDescription)
        }
        
        do {
            let count = try managedContext.count(for: dataSource.fetch)
            
            if count > 0 {
                coreDataSetup()
            } else {
                networkSetup()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func platformSetup() {
        for (index, filter) in filters.enumerated() {
            segmentedControl.insertSegment(withTitle: filter, at: index, animated: true)
        }
        dataSource.tableView = tableView
        fetchedResultsController = dataSource.fetchedResultsController
        edgesForExtendedLayout = []
        setupTableView()
        tableView.delegate = self
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(sender:)), for: .valueChanged)
    }
    
    func coreDataSetup() {
        state = .saved
        dataSource.state = .saved
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControlValueChanged(sender: segmentedControl)
    }
    
    func networkSetup() {
        state = .network
        dataSource.animating = true
        showLoadingView(loadingPop: loadingPop)
        getDataFromNetwork()
        state = .saved
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        switch state {
        case .network:
            if filters[sender.selectedSegmentIndex] == "Title" {
                selectedSection = "Title"
                sections = locations.map { $0.title! }
                let set = Set(self.sections)
                sections = Array(set)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if filters[sender.selectedSegmentIndex] == "Year" {
                selectedSection = "Year"
                sections = locations.map { $0.date }
                let set = Set(self.sections)
                sections = Array(set)
                dataSource.sections = self.dataSource.sectionDates.keys.map { $0 }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        case .saved:
            let fetchR = dataSource.fetchRequest
            if filters[sender.selectedSegmentIndex] == "Title" {
                selectedSection = "Title"
                dataSource.fetchRequest.sortDescriptors = dataSource.titleSortDescriptor
                dataSource.fetchedResultsController =  NSFetchedResultsController(fetchRequest: fetchR, managedObjectContext: managedContext, sectionNameKeyPath: "title", cacheName: nil)
            } else if filters[sender.selectedSegmentIndex] == "Year" {
                selectedSection = "Year"
                dataSource.fetchRequest.sortDescriptors = dataSource.dateSortDescriptor
                dataSource.fetchedResultsController =  NSFetchedResultsController(fetchRequest: fetchR, managedObjectContext: managedContext, sectionNameKeyPath: "date", cacheName: nil)
            }
            do {
                try dataSource.fetchedResultsController.performFetch()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                presentMessage(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

extension MainListViewController: TableViewable, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if selectedIndex != nil {
            if let previousCell = tableView.cellForRow(at: selectedIndex) as? FilmCell {
                previousCell.setSelected(false, animated: false)
                previousCell.layoutIfNeeded()
            }
        }
        if let selected = selectedIndex, selected == indexPath {
            selectedIndex = nil
            if let cell = tableView.cellForRow(at: indexPath) as? FilmCell {
                DispatchQueue.main.async {
                    cell.setSelected(false, animated: false)
                    cell.layoutIfNeeded()
                }
            }
        } else {
            selectedIndex = indexPath
            if let cell = tableView.cellForRow(at: indexPath) as? FilmCell {
                DispatchQueue.main.async {
                    cell.setSelected(true, animated: true)
                    self.getCoordinate(for: self.state, cell: cell) { error in
                        if let error = error {
                            self.presentMessage(title: "Error", message: error.localizedDescription)
                        }
                    }
                    tableView.layoutIfNeeded()
                    cell.layoutIfNeeded()
                }
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: self.selectedIndex, at: .top, animated: true)
                }
                tableView.layoutIfNeeded()
                cell.layoutIfNeeded()
            }
        }
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 14))
        view.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.96, alpha:1.0)
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? HeaderView else { return nil }
        header.backgroundView = view
        switch state {
        case .network:
            header.setText(string: sections[section], for: " ")
            return header
        case .saved:
            let title = dataSource.fetchedResultsController.sections![section]
            if self.selectedSection == "Title" {
                header.setText(string: title.name, for: " ")
            } else if self.selectedSection == "Year" {
                header.setText(string: String(title.name.prefix(4)), for: " ")
            }
            if let label = header.textLabel {
                CALayer.setupShadow(view: label)
            }
            return header
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 16
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selected = selectedIndex, indexPath.row == selected.row && indexPath.section == selected.section {
            return UIScreen.main.bounds.height / 2
        }
        return UIScreen.main.bounds.height / 4
    }
}

extension MainListViewController: MainListDataSourceDelegate {
    func stopAnimating() {
        DispatchQueue.main.async {
            self.hideLoadingView(loadingPop: self.loadingPop)
        }
    }
}
