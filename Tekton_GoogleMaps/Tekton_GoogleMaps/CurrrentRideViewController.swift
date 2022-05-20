//
//  ViewController.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 20/05/22.
//

import UIKit
import GoogleMaps
import CoreLocation

class CurrrentRideViewController: UIViewController {

    let manager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Current Ride"
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        GMSServices.provideAPIKey("AIzaSyAoSPIC5OEQcAC2CZG-k7RspDtn_GZNNoI")
    }
}
extension CurrrentRideViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}
