//
//  PlaceModels.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 27.08.2022.
//

import Foundation

struct Place: Decodable {
    let fsq_id: String
    let categories: [Category]
    let geocodes: Main
    let link: String
    let location: Location
    let name: String
    //"related_places": {},
    let timezone: String
    }



struct Location: Decodable {
   let country: String
   let cross_street: String?
   let formatted_address: String
}

struct Category: Decodable {
      let  id: Int
      let  name: String
      let  icon:  Icon
}

struct Icon: Decodable {
       let   prefix: String
       let   suffix: String
}

struct Main: Decodable {
    let main: GeoPoint
}

struct GeoPoint: Decodable {
  let latitude: Double
  let longitude: Double
}
    
    
    /*
    "fsq_id": "541327ea498ee067d851a158",
    "categories": [
        {
            "id": 11045,
            "name": "Bank",
            "icon": {
                "prefix": "https://ss3.4sqi.net/img/categories_v2/shops/financial_",
                "suffix": ".png"
            }
        }
    ],
    "chains": [],
    "geocodes": {
        "main": {
            "latitude": 49.940907,
            "longitude": 36.376236
        }
    },
    "link": "/v3/places/541327ea498ee067d851a158",
    "location": {
        "country": "UA",
        "cross_street": "",
        "formatted_address": ""
    },
    "name": "Uni Credit Bank",
    "related_places": {},
    "timezone": "Europe/Kiev"
}
*/
