//
//  CoordinateConverter.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/29/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class CoordinateConverter {
    func formatAddressString(addressString: String) -> String {
        var address = addressString.replacingOccurrences(of: "(", with: "")
        address = address.replacingOccurrences(of: ")", with: "")
        if let lowerBound = address.range(of: " at ")?.lowerBound {
            return String(address[..<lowerBound]) + ", San Francisco"
        } else {
            return address + ", San Francisco"
        }
    }
    
    func getAddress(from addressString: String) -> String {
        let formatted = formatAddressString(addressString: addressString) + ", CA"
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
            let matches = detector.matches(in: formatted,
                                           options: [],
                                           range: NSRange(location: 0, length: formatted.utf16.count))
            
            var resultsArray =  [[NSTextCheckingKey: String]]()
            for match in matches {
                if match.resultType == .address,
                    let components = match.addressComponents {
                    resultsArray.append(components)
                } else {
                    print("no components found")
                }
            }
            if resultsArray.count > 0 {
                for address in resultsArray {
                    if let street = address[NSTextCheckingKey.street],
                        let city = address[NSTextCheckingKey.city], let state = address[NSTextCheckingKey.state] {
                        let searchString = street + ", " + city + ", " + state
                        return searchString
                    }
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return formatted
    }
    
    func getCoordinates(searchString: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let localSearchRequest = MKLocalSearchRequest()
        
        localSearchRequest.naturalLanguageQuery = searchString
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { localSearchResponse, error in
            if error != nil {
                completion(nil, error)
            } else {
                completion(localSearchResponse?.mapItems.first?.placemark.coordinate, nil)
            }
        }
    }
}
