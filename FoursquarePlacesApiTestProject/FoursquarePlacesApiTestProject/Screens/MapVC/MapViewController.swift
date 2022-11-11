//
//  MapViewController.swift
//  FoursquarePlacesApiTestProject
//
//  Created by Fedii Ihor on 14.09.2022.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController {
    
    let regionRadius: Double
    let userLocation: CLLocation
    var places: [Place]
    let termText: String
    let termPlaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your location is now"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 50, weight: .semibold)
        return label
    }()
   private let mapView: MKMapView = {
       let view = MKMapView()
        view.mapType = .mutedStandard
       return view
    }()
    
    init(location: CLLocation,places: [Place],regionRadius: Double = 1000 ,termText: String) {
        self.userLocation = location
        self.places = places
        self.regionRadius = regionRadius
        self.termText = termText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.centerToLocation(userLocation, regionRadius: regionRadius)
        let region = MKCoordinateRegion(center: userLocation.coordinate,
                                        latitudinalMeters: 6000,
                                        longitudinalMeters: 6000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        mapView.register(PlacePinView.self,
        forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupUI()
        setupPlaces()
    }
    
    private func setupUI() {
        view.backgroundColor =  .systemBackground
        termPlaceLabel.text = termText
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
        view.addSubview(termPlaceLabel)
        termPlaceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.trailing.equalToSuperview().inset(20)
            
        }
    }
    
    private func setupUserPosition() {
        let pin = MKPointAnnotation()
        pin.coordinate = userLocation.coordinate
        mapView.addAnnotations([pin])
    }
    
    private func setupPlaces() {
      let points = places.map { PlaceMapPin(place: $0) }
      mapView.addAnnotations(points)
    }
  
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                    annotationView view: MKAnnotationView,
                    calloutAccessoryControlTapped control: UIControl) {
      //обьект передаваемый картам
      guard let place = view.annotation as? PlaceMapPin else { return }
      let launchOptions = [
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
      ]
      place.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//      let view =  mapView.dequeueReusableAnnotationView(
//        withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
//        for: annotation ) as! PlacePinView
//        return view
//    }
    
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation,
                          regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
