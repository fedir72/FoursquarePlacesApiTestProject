//
//  PlacePinView.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 17.09.2022.
//

import Foundation
import MapKit
import SDWebImage
import SnapKit

class PlacePinView: MKAnnotationView {
    var photoUrl: URL? {
        didSet {
            imageView.sd_setImage(with: self.photoUrl,
            placeholderImage: UIImage(systemName: "questionmark"))
        }
    }
    
  override var annotation: MKAnnotation? {
    willSet {
      guard let _ = newValue as? PlaceMapPin else { return }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
        let mapsButton: UIButton = {
           let btn = UIButton(frame: CGRect(origin: CGPoint.zero,
                               size: CGSize(width: 35, height: 40)))
            btn.layer.cornerRadius = 8
            btn.clipsToBounds = true
            btn.setBackgroundImage(UIImage(named: "mapButton"), for: .normal)
            return btn
        }()
        rightCalloutAccessoryView = mapsButton
    }
      didSet {
          if let place = annotation as? PlaceMapPin {
              photoUrl = place.imageUrl
          }
      }
  }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = self.bounds
        addSubview(imageView)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = 20.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.backgroundColor = UIColor(named: "MapColor")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
   
}
