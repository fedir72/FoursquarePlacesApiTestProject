//
//  UserLocationManager.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 30.08.2022.
//

import Foundation
import CoreLocation

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = UserLocationManager()
    let manager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    public func resolveLocationName(with location: CLLocation,
                                    completion: @escaping ((String?) -> Void ))   {
       let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale:  .current)
        { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            print(place)
            var name = ""
            if let locality = place.locality {
                name+=locality
            }
            if let adminregion = place.administrativeArea {
                name+=", \(adminregion)"
            }
            completion(name)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                           didUpdateLocations locations: [CLLocation]) {
        print("didstop")
        guard let location = locations.first else { return }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}
