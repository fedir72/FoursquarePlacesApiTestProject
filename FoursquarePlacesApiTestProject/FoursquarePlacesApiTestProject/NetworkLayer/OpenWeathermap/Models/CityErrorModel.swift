//
//  CityErrorModel.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation

struct CityErrorModel: Codable {
    let cod: Int
    let message: String
}

//"{\"cod\":401, \"message\": \"Invalid API key. Please see https://openweathermap.org/faq#error401 for more info.\"}"
