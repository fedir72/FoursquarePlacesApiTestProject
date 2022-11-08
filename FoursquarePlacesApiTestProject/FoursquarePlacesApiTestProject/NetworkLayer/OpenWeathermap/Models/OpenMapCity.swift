//
//  CityModel.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
struct OpenMapCity: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}

extension OpenMapCity {
   var coordinateText: String {
       return "lat: \(lat),lon: \(lon)"
    }
}

