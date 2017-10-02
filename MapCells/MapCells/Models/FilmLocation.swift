//
//  FilmLocation.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/30/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class FilmLocation: NSObject, Encodable, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    var locationName: String {
        didSet {
            print(locationName)
        }
    }
    
    var uid: String
    var date: String
    var latitude: Double
    var longitude: Double
    
    init?(data: [Any]) {
        guard let uid = data[1] as? String,
            let title = data[8] as? String,
            let year = data[9] as? String,
            let addressString = data[10] as? String
            else {
                return nil
        }
        self.uid = uid
        self.title = title
        self.date = year
        self.locationName = addressString
        self.latitude = 0
        self.longitude = 0
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init()
    }
    
    init(locationName: String, title: String, date: String, coordinate: CLLocationCoordinate2D, uid: String) {
        self.title = title
        self.locationName = locationName
        self.date = date
        self.coordinate = coordinate
        self.uid = uid
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "title", locationName = "locationName", uid = "uid", date = "date", latitude = "latitude", longitude = "longitude"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(uid, forKey: .uid)
        try container.encode(date, forKey: .date)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
