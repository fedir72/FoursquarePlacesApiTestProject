//
//  FavoritePlace.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
import RealmSwift
import CoreLocation


class RealmFavoriteCity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var lat: Double = 0.0
    @Persisted var lon: Double = 0.0
    @Persisted var country: String = ""
    @Persisted var state: String = ""
    @Persisted var places: List<RealmMapPlace>
    
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

extension RealmFavoriteCity {
    
    static func createFavoriteCity(by weatherModel: OpenMapCity) -> RealmFavoriteCity {
        return RealmFavoriteCity(name: weatherModel.name,
                            lat: weatherModel.lat,
                            lon: weatherModel.lon,
                            country: weatherModel.country ,
                            state: weatherModel.state )
    }

}
