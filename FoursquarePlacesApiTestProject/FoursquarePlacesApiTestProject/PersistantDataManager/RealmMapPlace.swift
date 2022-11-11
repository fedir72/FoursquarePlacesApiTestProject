//
//  MapPlace.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 04.11.2022.
//

import Foundation
import RealmSwift

class RealmMapPlace:  EmbeddedObject {
   //embedded object can not have id 
    @Persisted var name: String = ""
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0
    
    convenience init(name: String, lat: Double, long: Double) {
        self.init()
        self.name = name
        self.latitude = lat
        self.longitude = long
    }
}
