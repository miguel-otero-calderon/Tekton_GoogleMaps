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
        init(source: MapViewModel.Location, destination: MapViewModel.Location?, timer: MapViewModel.Timer?) {
            self.id = getId()
            self.source = source
            self.destination = destination
            self.timer = timer
        }
        
        let id:String
        let source: Location
        let destination: Location?
        let timer: Timer?
        
        func getDistance() -> Double {
            let sourceLocation = source.location
            guard let destinationLocation = destination?.location else {
                return 0.0
            }
            let distanceInMeters = sourceLocation.distance(from: destinationLocation)
            return distanceInMeters/1000
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
}
