//
//  MainListDataStore.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreData

class MainListDataStore {
    
    func getDataFromNetwork(managedContext: NSManagedObjectContext, completion: @escaping ([FilmLocation])->Void) {
        var locations: [FilmLocation] = []
        var urlComponents = URLComponents(string: "\(URLRouter.base.url)")!
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: String(5)),
            URLQueryItem(name: "offset", value: String(0))
        ]
        SkyAPI.search(urlComponent: urlComponents) { response in
            switch response {
            case .failed(let error):
                print(error.localizedDescription)
            case .success(let json):
                guard let data = json["data"] as? [[Any]] else { return }
                for  i in 0..<data.count {
                    if let newLocation = FilmLocation(data: data[i]), let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext) {
                        let movie = Movie(entity: entity, insertInto: managedContext)
                        movie.title = newLocation.title!
                        movie.locationName = newLocation.locationName
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy"
                        let dateObj = dateFormatter.date(from: newLocation.date)
                        if let nsDate = dateObj as NSDate? {
                            movie.date = nsDate
                        }
                        do {
                            try? managedContext.save()
                        }
                        locations.append(newLocation)
                    }
                }
                completion(locations)
            }
        }
    }
}
