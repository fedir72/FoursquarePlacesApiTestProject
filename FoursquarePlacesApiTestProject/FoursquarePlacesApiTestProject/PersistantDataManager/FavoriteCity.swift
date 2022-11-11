//
//  FavoritePlace.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
import RealmSwift
import CoreLocation


class FavoriteCity: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var lat: Double = 0.0
    @Persisted var lon: Double = 0.0
    @Persisted var country: String = ""
    @Persisted var state: String = ""
    @Persisted var places: List<MapPlace>
    
    convenience init(name: String,
                     lat: Double,
                     lon: Double,
                     country: String? ,
                     state: String? ) {
        self.init()
        self.name = name
        self.lat = lat
        self.lon = lon
        self.state = state ?? ""
        self.country = country ?? ""
    }
    
    func createCLLocation() -> CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.lon)
    }
    
}

extension FavoriteCity {
    
    static func createFavoriteCity(by weatherModel: OpenMapCity) -> FavoriteCity {
        return FavoriteCity(name: weatherModel.name,
                            lat: weatherModel.lat,
                            lon: weatherModel.lon,
                            country: weatherModel.country ,
                            state: weatherModel.state )
    }
    
//    static func createCLLocation(by city: FavoriteCity) -> CLLocation {
//        return CLLocation(latitude: city.lat, longitude: city.lon)
//    }
    
}
