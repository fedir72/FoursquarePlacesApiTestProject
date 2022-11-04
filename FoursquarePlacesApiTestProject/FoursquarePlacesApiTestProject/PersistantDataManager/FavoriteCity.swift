//
//  FavoritePlace.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
import RealmSwift

class FavoriteCity: Object, PlaceProtocol {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var lat: Double = 0.0
    @Persisted var lon: Double = 0.0
    @Persisted var country: String? = ""
    @Persisted var state: String? = ""
    @Persisted var places: List<MapPlace>
    
    convenience init(name: String,
                     lat: Double,
                     lon: Double,
                     country: String? = "" ,
                     state: String? = "") {
        self.init()
        self.name = name
        self.lat = lat
        self.lon = lon
        self.state = state
        self.country = country
    }
}

extension FavoriteCity {
    
    static func getTestdata() -> [FavoriteCity] {
        return
        [FavoriteCity(name: "Goro", lat: 44.850883,
                      lon: 12.294927, country:"UI", state: "Banana"),
        FavoriteCity(name: "Goro", lat: 44.850883,
                     lon: 12.294927, country:"UI", state: "Banana"),
        FavoriteCity(name: "Gór", lat: 47.3598534,
                     lon: 16.8041843, country:"UI", state: "Banana"),
        FavoriteCity(name: "Gór", lat: 47.3598534,
                     lon: 16.8041843, country:"UI", state: "Banana"),
        FavoriteCity(name: "Goro", lat: 44.850883,
                     lon: 12.294927, country:"UI", state: "Banana"),
        FavoriteCity(name: "Gór", lat: 47.3598534,
                     lon: 16.8041843, country:"UI", state: "Banana")]
    }
}
