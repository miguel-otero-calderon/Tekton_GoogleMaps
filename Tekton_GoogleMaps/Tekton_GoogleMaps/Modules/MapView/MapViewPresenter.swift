//
//  MapViewPresenter.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 22/05/22.
//

import Foundation
import GoogleMaps
import CoreLocation

protocol MapViewPresenterProtocol {
    func getInformation(coordinate: CLLocationCoordinate2D)
}

class MapViewPresenter {
    var view: MapViewController?
    
    init(view: MapViewController) {
        self.view = view
    }
    
}
extension MapViewPresenter  {
    func getAddress(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult() else {
                return
            }
            self.view?.getAddress(address: address)            
        }
    }
}
