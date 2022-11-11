//
//  PlaceMapPin.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 15.09.2022.
//

import Foundation
import MapKit
import Contacts
import SDWebImage

class PlaceMapPin: NSObject, MKAnnotation {
    
    let imageUrl: URL?
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    var locationName: String? {
        return title
    }
    
    var markerTintColor: UIColor  {
        return .blue
    }
  
    init(place: Place ) {
        self.imageUrl = place.categories[0].icon.iconURl(resolution: .small) 
        self.title = place.name
        self.subtitle = place.categories[0].name
        self.coordinate = .init(latitude: place.geocodes.main?.latitude ?? 0.0,
                                longitude: place.geocodes.main?.longitude ?? 0.0)
    }
    
    var mapItem: MKMapItem? {
      guard let location = locationName else {
        return nil
      }

      let addressDict = [CNPostalAddressStreetKey: location]
      let placemark = MKPlacemark(
        coordinate: coordinate,
        addressDictionary: addressDict)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = title
      return mapItem
    }
    
    
}
