//
//  FilmLocationAnnotation.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 10/1/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit

class FilmLocationAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
