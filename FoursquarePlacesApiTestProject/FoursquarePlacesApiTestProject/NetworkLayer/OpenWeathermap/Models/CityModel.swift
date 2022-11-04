//
//  CityModel.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
struct CityModel: Decodable, PlaceProtocol {
    let name: String
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}

extension CityModel {
   var coordinateText: String {
       return "lat: \(lat),lon: \(lon)"
    }
}

