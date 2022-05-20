//
//  ViewController.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 20/05/22.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {

    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        GMSServices.provideAPIKey("AIzaSyAoSPIC5OEQcAC2CZG-k7RspDtn_GZNNoI")
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}
