//
//  MapViewModel.swift
//  Tekton_GoogleMaps
//
//  Created by Miguel on 22/05/22.
//

import Foundation
import CoreLocation

struct MapViewModel {
    struct Route {
        init(id:String, source: MapViewModel.Location, destination: MapViewModel.Location?, timer: MapViewModel.Timer?) {
            self.id = id
            self.source = source
            self.destination = destination
            self.timer = timer
        }
        
        let id:String
        let source: Location
        let destination: Location?
        let timer: Timer?
        
        func getDistanceKms() -> Double {
            let sourceLocation = source.location
            guard let destinationLocation = destination?.location else {
                return 0.0
            }
            let distanceInMeters = sourceLocation.distance(from: destinationLocation)
            let distanceInKilometres = distanceInMeters/1000
            return distanceInKilometres
        }
        func getDistanceKmsString() -> String {
            let distanceInKilometres = getDistanceKms().toString(decimal: 2)
            return "\(distanceInKilometres) km"
        }
    }
    struct Location {
        let location: CLLocation
        let address: String
    }
    struct Timer {
        
        let hours:Int
        let minutes:Int
        let seconds:Int
        
        init(mySeconds: Int) {
            hours = mySeconds / 3600
            minutes = (mySeconds % 3600) / 60
            seconds = (mySeconds % 3600) % 60
        }
        
        init(hours: Int, minutes: Int, seconds: Int) {
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
        }
        
        func toString() -> String {
            var timeString = ""
            timeString += String(format: "%02d", hours)
            timeString += " : "
            timeString += String(format: "%02d", minutes)
            timeString += " : "
            timeString += String(format: "%02d", seconds)
           return timeString
        }
    }
    enum TypeRequest {
        case initLocation
        case finishLocation
        case noRoute
    }
}
