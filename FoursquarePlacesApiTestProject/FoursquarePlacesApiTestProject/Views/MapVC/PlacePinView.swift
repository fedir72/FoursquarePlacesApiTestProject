//
//  PlacePinView.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 17.09.2022.
//

import Foundation
import MapKit
import SDWebImage

class PlacePinView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let place = newValue as? PlaceMapPin else { return }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      markerTintColor = place.markerTintColor
    glyphImage = UIImage(systemName: "globe")
    }
  }
}
