//
//  SkyAPIClient.swift
//  SkyProject
//
//  Created by Christopher Webb-Orenstein on 9/29/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation

class SkyAPI {
    static func search(urlComponent: URLComponents, _ completion: @escaping (Response<JSON>) -> Void) {
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("X-App-Token", forHTTPHeaderField: "L3ng0vJbF0wSz9Jz45YfRMRCF")
        urlRequest.setValue("Host", forHTTPHeaderField: "data.sfgov.org")
        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data, let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else { return }
                    if let object = responseObject {
                        DispatchQueue.main.async {
                            completion(Response<JSON>.success(object))
                        }
                    }
                }
            }}.resume()
    }
    
    static func search(_ completion: @escaping (Response<JSON>) -> Void) {
        let urlString = URLRouter.base.url
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("X-App-Token", forHTTPHeaderField: "L3ng0vJbF0wSz9Jz45YfRMRCF")
        urlRequest.setValue("Host", forHTTPHeaderField: "data.sfgov.org")
        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failed(error))
            } else {
                do {
                    guard let data = data,
                        let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON else { return }
                    if let object = responseObject {
                        DispatchQueue.main.async {
                            completion(Response<JSON>.success(object))
                        }
                    }
                }
            }}.resume()
    }
}
