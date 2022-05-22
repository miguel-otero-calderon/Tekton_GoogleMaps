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
    func secondsToHoursMinutesSeconds(seconds:Int) -> (Int,Int,Int)
    func makeTimeString(hours: Int, minutes: Int, seconds: Int ) -> String
    func getAddress(coordinate: CLLocationCoordinate2D)
}

class MapViewPresenter {
    var view: MapViewControllerProtocol?
    
    init(view: MapViewControllerProtocol) {
        self.view = view
    }
    
}
extension MapViewPresenter: MapViewPresenterProtocol {
    
    func getAddress(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let myAddress = response?.firstResult() else {
                return
            }
            guard let lines = myAddress.lines else {
                return
            }
            let address = lines.joined(separator: "\n")
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let myLocation = MapViewModel.Location(
                location: location,
                address: address)
            
            self.view?.getLocation(location: myLocation)
        }
    }
    func secondsToHoursMinutesSeconds(seconds:Int) -> (Int,Int,Int) {
        return ((seconds / 3600),
                ((seconds % 3600) / 60),
                ((seconds % 3600) % 60)
        )
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int ) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
       return timeString
    }
}
