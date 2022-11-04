//
//  CityModel.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
struct CityModel: Decodable {
    let name: String?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?
}

extension CityModel {
   var coordinateText: String {
       return "lat: \(lat ?? 0.0),lon: \(lon ?? 0.0)"
    }
}

